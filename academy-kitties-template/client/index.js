var web3 = new Web3(Web3.givenProvider);

var instance; 
var user;
var contractAddress = "0x8955C96CC19A232eebA34106073E22b917e591D2";

$(document).ready(function(){
    window.ethereum.enable().then(function(accounts) {
        instance = new web3.eth.Contract(abi, contractAddress, {from: accounts[0]});
        user = accounts[0];

        console.log(instance);
        
    })
})

async function createKitty() {
    var dnaString = getDna();
    console.log(dnaString);
    await instance.methods.createKittyGen0(dnaString).send({}, function(error, txHash) {
        if(error) {
            console.log(error);
        } else {
            console.log(txHash);
            instance.events.Birth().on('data', function(event){
                console.log(event);
                let owner = event.returnValues.owner;
                console.log(owner);
                let newKittenId = event.returnValues.newKittenId;
                console.log(kittenId);
                let momId = event.returnValues.momId;
                console.log(momId);
                let dadId = event.returnValues.dadId;
                console.log(dadId);
                let genes = event.returnValues.genes;
                console.log(genes);

                $("#kittyCreated").css("display", "block");
                $("#kittyCreated").text("Kitten Id: " + newKittenId +
                                       " Owner: " + owner + 
                                       " MumId: " + momId + 
                                       " DadId: " + dadId +
                                       " Genes: " + genes );
            }) 
            .on('error', console.error); 
        }
    })
}
