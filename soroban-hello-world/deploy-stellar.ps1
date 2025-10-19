Param()

Write-Host "1) Build wasm bằng soroban..."
soroban contract build
if ($LASTEXITCODE -ne 0) { Write-Error "Build thất bại"; exit 1 }

# Nhập thông tin
$wasmDefault = "target/wasm32v1-none/release/royalty.wasm"
$wasm = Read-Host "Đường dẫn .wasm (Enter để dùng mặc định: $wasmDefault)"
if ([string]::IsNullOrWhiteSpace($wasm)) { $wasm = $wasmDefault }

$secret = Read-Host "Secret key để ký (bắt đầu bằng S...)" 
$alias = Read-Host "Alias muốn đặt cho contract (ví dụ: royalty)"

Write-Host ""
Write-Host "2) Deploy contract lên testnet với Stellar CLI..."
Write-Host "Lệnh:"
Write-Host "stellar contract deploy --wasm `"$wasm`" --source-account `"$secret`" --network testnet --alias $alias"
Write-Host ""

# Thực thi deploy
& stellar contract deploy --wasm $wasm --source-account $secret --network testnet --alias $alias
if ($LASTEXITCODE -ne 0) { Write-Error "Deploy thất bại"; exit 1 }

Write-Host ""
Write-Host "Deploy xong. Alias và contract-id được lưu vào .stellar/contract-ids\$alias.json"
$useAlias = Read-Host "Bạn muốn chạy invoke mẫu ngay bây giờ? (y/N)"
if ($useAlias -ne 'y' -and $useAlias -ne 'Y') { Write-Host "Hoàn tất."; exit 0 }

# Nhập tham số invoke
$contractIdOrAlias = $alias
$token = Read-Host "Token id (khi contract yêu cầu BytesN: 64 hex chars; hoặc nếu bạn dùng String, nhập chuỗi dễ đọc)"
$creator = Read-Host "Creator id (64 hex hoặc chuỗi tùy contract)"
$bps = Read-Host "BPS (ví dụ 500 cho 5%)"
$price = Read-Host "Giá test cho compute_royalty (ví dụ 1000000)"

Write-Host ""
Write-Host "3) Invoke register (mặc định simulate; thêm --send=yes để gửi thật)"
$registerCmd = "stellar contract invoke --id $contractIdOrAlias --source-account `"$secret`" --network testnet -- register --token `"$token`" --creator `"$creator`" --bps $bps --send=yes"
Write-Host $registerCmd
& stellar contract invoke --id $contractIdOrAlias --source-account $secret --network testnet -- register --token $token --creator $creator --bps $bps --send=yes
if ($LASTEXITCODE -ne 0) { Write-Warning "Register có thể failed (xem output)"; }

Write-Host ""
Write-Host "4) Invoke compute_royalty (simulate)"
$computeCmd = "stellar contract invoke --id $contractIdOrAlias --source-account `"$secret`" --network testnet -- compute_royalty --token `"$token`" --price $price"
Write-Host $computeCmd
& stellar contract invoke --id $contractIdOrAlias --source-account $secret --network testnet -- compute_royalty --token $token --price $price

Write-Host ""
Write-Host "Hoàn tất. Kiểm tra output ở trên và xem transaksi trên explorer nếu đã gửi."
