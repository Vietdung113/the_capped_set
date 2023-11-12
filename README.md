# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```


## Deployed contract
```shell
npx hardhat run scripts/deploy.ts --network sepolia
```
- Address: 0x25EF5a09fB8a450e89d5e7CBb27f332a8823d364
- numElements: 10

### Verify contract 
```shell
npx hardhat verify --network sepolia 0x25EF5a09fB8a450e89d5e7CBb27f332a8823d364 10
```
- The contract link: https://sepolia.etherscan.io/address/0xBE25d7165a81A2f15D894F9DA076dd8f626CE371#code