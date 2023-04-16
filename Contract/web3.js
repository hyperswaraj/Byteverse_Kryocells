import Web3 from 'web3';
import RideShareContract from './contracts/RideShare.json';

const web3 = new Web3(Web3.givenProvider || 'http://localhost:8545');
const contractAddr = '0x123...';

const rideShareContract = new web3.eth.Contract(RideShareContract.abi, contractAddr);

export default rideShareContract;
