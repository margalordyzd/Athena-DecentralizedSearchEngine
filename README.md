# Athena-DecentralizedSearchEngine
This is an Ethereum blockchain implementation of a decentralized search engine that allows anyone in the world to browse and upload a website with a given topic or set of topics.

## How the search engine works

### PAckages needed:

Athena was build on top of a truffle framwork using the following:
  * Solidity contract.
  * Web3.js to comunicate with the contract.
  * IPFS for the storage of the actual websites.
  * OpenZeppelin to improve the security of the contract.
  * SafeMath modules to avoid overflow and Underflow flaws.

### Athena websites:

Athena allows everyone to register a website by making a call to the contract with the:
  * Name of the contract.
  * Price that the owner of the contract is willing to pay for each review.
  * The IPFS address to the website.
  * The topics that are referenced inside the website according to the uploader.
  * A max number of reviews that the uploader is willing to pay.
 
 ### Website Validations:
 
 To ensure that the search engine works properly and actually returns the results that correspond to the searched topic, the users of athena are incentivized to make reviews and validate what the uploader say are the topics of his website. This is done with the creation of the ATN token.
 
 ```solidity
import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract WebValidation is MintableToken {
    string public name = "Athena";
    string public symbol = "ATN";
    uint8 public decimals = 18;
}
```
The token was created with OpenZeppelin as a mintable token in order to have a controlled supply and allow the owner of the contract to emit tokens and assign them.(Given the nature of this token, a certain degree of trust is required from the comunity to the owner of the contract which can be improved).

Any user that is not the uploader of the website can give a revie to any new website. this is done by sumbitting a list of booleans wich lenght is equal to the lenght of the topic list selected by the uploader(the owner of the website), meaning that a reviewer gives either a possitive or a negative review to eachone of the topics proposed by the owner.

After the review is submitted, the reviewer is paid with tokens from the uploaders account; one unit is also substracted from the maximum number of reviews that the uploader is willing to pay.

#### End of validation

The validation process finishes once the maximum number of reviews selected by the uploader is reached, or onces the threshold of positive reviews needed for a topic is crossed (meaning that the website was accepted under a given topic).

The positive reviews threshold is selected by the owner of the contract and can be modified at any time given the OpenZeppelin function 'Ownable':
 
 ```solidity
 function setReviewThreshold(uint _reviews) external onlyOwner{
        reviews = _reviews;
    }
```
 when the threshold is crossed for a given topic, the id of the website is added to a mapping that maps a topic with a list of websites that correspond to that topic. Any given user can call the function 'searchByTopic' and retrive a list of all the IPFS websites that correspond to that topic:
 
  ```solidity
 function searchByTopic(string _topic) public view returns(string[]) {
        uint[] ids = getPath(_topic);
        string[] paths;
        for(uint i =0;i<ids.length;i++){
            paths.push(websites[ids[i]].ipfs);
        }
        return paths;
```


 
 
