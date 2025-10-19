#![cfg(test)]

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
