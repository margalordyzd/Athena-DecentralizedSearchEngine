pragma solidity ^0.4.19;

import "./Token.sol";

contract Athena is Token {
    
    using SafeMath for uint256;
    using SafeMath for int256;
    
    struct Site {
        string name;
        uint price;
        string ipfs;
        uint[] topics;
        uint maxReviewing;
        mapping (uint => int) scores;
        uint timesReviewed;
    }
    
    uint reviews = 10;
    
    Site[] public websites;
    
    mapping (uint => address) public webToOwner;
    mapping (uint => uint[]) topicToSite;
    mapping (string => uint) topicToId;
    
    

    /**
   * @dev This function manages the creation of a website in the blockchain
   * @param _name string The name of the website
   * @param _price uint256 The price that the uploader is willing to pay for each validation
   * @param _ipfs string The hash that corresponds to an IPFS website
   * @param _topics uint256 An array of numbers that correspond to the topics of the website
   * @param _maxReviewing uint256 The max amount of reviews that the owner is willing to pay
   */
    
    function _createSite(string _name,uint _price, uint[] _topics, string _ipfs, uint _maxReviewing) external{
        require(_maxReviewing >= reviews);
        mapping(uint =>uint) memory temp;
        uint id = websites.push(Site(_name, _price, _ipfs,_topics,_maxReviewing,temp,0)) - 1;
        webToOwner[id] = msg.sender;
    }
    
    /**
     * @dev This function allows the owner to set the minimum number of reviews that a website needs to be considered under a given topic
     * @param _reviews uint256 The new minimum number of required reviews.
    */
    
    function setReviewPrice(uint _reviews) external onlyOwner{
        reviews = _reviews;
    }
    
    /**
     * @dev This function lets a given user review a website and evaluate if it corresponds to a given topic.
     * @param _review bool[] An array of boolens that correspond to either a negative or a positive review for each of the suggested topics
     * @param _id uint256 The identifier correspondig to the website being timesReviewed
    */
    
    function reviewSite(bool[] _review,uint _id) external{
        require(_review.length == websites[_id].topics.length);
        require(balances[webToOwner[_id]>= websites[_id].price]);
        require(websites[_id].timesReviewed < websites[_id].maxReviewing);
        require(webToOwner[_id] != msg.sender);
        transferFrom(webToOwner[_id],msg.sender,websites[_id].price);
        
        uint[] memory topicsTemp = websites[_id].topics;
        for(uint i;i<_review.length;i++){
            int memory valueRev = _review[i] ? 1 : -1;
            websites[_id].scores[topicsTemp[i]].add(valueRev);
            if (websites[_id].scores[topicsTemp[i]] >= reviews){
                topicToSite[topicsTemp].push(_id);
            }
        }
        websites[_id].timesReviewed.add(1);
        
    }
    
    /**
     * @dev Function that enables a user to retrieve the correspondig ipfs paths of all the websites of a given topicsTemp
     * @param _topic string The topic to search for
    */
    
    function searchByTopic(string _topic) public view returns(string[]) {
        uint[] ids = getPath(_topic);
        string[] paths;
        for(uint i =0;i<ids.length;i++){
            paths.push(websites[ids[i]].ipfs);
        }
        return paths;

    }
    
    function getPath(string _topic) internal returns(uint[]) {
        return topicToSite[topicToId[_topic]];
    }
    
    /**
     * @dev This function enables the owner to select the id of a given topicToId
    */
    
    function createTopicId(string _topic,uint _topicId) external onlyOwner{
        topicToId[_topic] = _topicId;
    }
        
    
} 
