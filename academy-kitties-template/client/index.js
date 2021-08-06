var web3 = new Web3(web3.givenProvider);

var instance; 
var user;
var conractAddress;

$(document).ready(function(){
    window.ethereum.enable().then(function(accounts){
        instance = new web3.eth.contract(abi, conractAddress, {from: accounts[0]})
        user = accounts[0];

        console.log(instance);
    })
})
