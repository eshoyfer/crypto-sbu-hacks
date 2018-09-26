// ### USAGE 
// node deploy.js --contractPath=MyContractFile.sol --contractName=MyContract --contractInputParams=Name1,Name2

const fs = require('fs');
const Web3 = require('web3');
const solc = require('solc');

// https://github.com/substack/minimist for usage examples and docs
const argv = require('minimist')(process.argv.slice(2));

// Connect to local Ethereum node
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
console.log(web3.eth.getAccounts());
let inputParamsArray = argv.contractInputParams.split(',');
let inputParams = inputParamsArray.map(web3.fromAscii);

// Compile the source code
const input = fs.readFileSync(argv.contractPath);
const output = solc.compile(input.toString(), 1);
const bytecode = output.contracts[`:${argv.contractName}`].bytecode;

console.log('---');
console.log('ABI: ' + output.contracts[`:${argv.contractName}`].interface);
const abi = JSON.parse(output.contracts[`:${argv.contractName}`].interface);

let accounts, contract, toDeploy, estimatedGas, gasPrice;

// Get average gas price
web3.eth.getGasPrice((error, result) => {
    if (error) reject(error)
    
    console.log('---');
    console.log('Gas price: ', result);
    
    gasPrice = web3.toHex(result);
});

// Promises chain: get accounts, instantiate new contract, gas estimate, contract deploy
web3.eth.accounts
    .then((acc) => {
        accounts = acc;
        return getNewContract(abi, accounts[0], bytecode);
    })
    .then((c) => {
        contract = c;
        return getContractDeployOjb(
            contract, bytecode, [inputParams]);
    })
    .then((td) => {
        toDeploy = td;
        return getEstimatedGas(toDeploy);
    })
    .then((gas) => {
        estimatedGas = gas;
    
        toDeploy.send({
            from: accounts[0],
            gas: estimatedGas,
            gasPrice: gasPrice
        })
        .then((instance) => { 
            console.log('---');
            console.log("Contract mined at " + instance.options.address);
            contractInstance = instance; 
        });
    });

const getNewContract = (abi, from, data) => {
    return new Promise((resolve, reject) =>  {
        const contractInstance = new web3.eth.Contract( abi, from, { data: data });
        resolve(contractInstance);
    })
}

const getContractDeployOjb = (contract, data, args)  => {
    return new Promise((resolve, reject) =>  {
    
        resolve(contract.deploy({ 
            data: data,
            arguments: args
        }));
    })
}

const getEstimatedGas = (toDeploy) => {
    return new Promise((resolve, reject) => {
      
        toDeploy.estimateGas((error, result) => {
            if (error) reject(error);
      
            console.log('---');
            console.log('Estimated Gas: ', result);
            resolve(web3.toHex(parseInt(result * 1.1)))
        })
    })
}