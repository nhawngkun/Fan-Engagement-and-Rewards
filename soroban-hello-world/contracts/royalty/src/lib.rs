#![no_std]
use soroban_sdk::{contract, contractimpl, BytesN, Env};

#[contract]
pub struct RoyaltyContract;

#[contractimpl]
impl RoyaltyContract {
    // Register a creator and royalty bps (basis points) for a given token id.
    // token: BytesN<32> - canonical token id chosen by your application
    // creator: BytesN<32> - canonical creator identifier (32-byte)
    // bps: i32 - basis points (e.g. 500 = 5%)
    pub fn register(env: Env, token: BytesN<32>, creator: BytesN<32>, bps: i32) {
        // Validate input
        if bps < 0 || bps > 10000 {
            panic!("bps must be between 0 and 10000");
        }

        // Store data
        let storage = env.storage().instance();
        storage.set(&token, &(creator.clone(), bps));

        // Publish event as a tuple (topics, data) where data is a tuple (token, creator, bps)
        env.events()
            .publish(("register",), (token.clone(), creator.clone(), bps));
    }

    // Compute royalty for a given token id and sale price.
    // Returns (creator, royalty_amount). If no royalty is registered, returns zeroed creator and 0.
    pub fn compute_royalty(env: Env, token: BytesN<32>, price: i128) -> (BytesN<32>, i128) {
        let storage = env.storage().instance();

        if let Some((creator, bps)) = storage.get::<_, (BytesN<32>, i32)>(&token) {
            let royalty = (price * (bps as i128)) / 10000i128;
            (creator, royalty)
        } else {
            // Return zeroed creator and 0 royalty if not found
            (BytesN::from_array(&env, &[0u8; 32]), 0)
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use soroban_sdk::{testutils::BytesN as _, Env};

    #[test]
    fn test_royalty() {
        let env = Env::default();
        let contract_id = env.register(RoyaltyContract, ());
        let client = RoyaltyContractClient::new(&env, &contract_id);

        // Test data
        let token = BytesN::random(&env);
        let creator = BytesN::random(&env);
        let bps = 500; // 5%
        let price = 10000;

        // Test register
        client.register(&token, &creator, &bps);

        // Test compute_royalty
        let (result_creator, royalty) = client.compute_royalty(&token, &price);
        assert_eq!(result_creator, creator);
        assert_eq!(royalty, (price as i128) * (bps as i128) / 10000);
    }
}
