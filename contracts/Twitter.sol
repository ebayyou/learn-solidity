// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Twitter {

    // struct
    uint16 public MAX_TWEET_LENGTH = 200;
    address public owner;

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;

    constructor() {
        owner = msg.sender;
    }

    // modifier

    modifier onlyOwner() {
        require(msg.sender == owner, "YOU ARE NOT THE OWNER!");
        _;
    }

    // method

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is to high, bro!");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST!");

        tweets[author][id].likes++;
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST!");
        require(tweets[author][id].likes > 0, "TWEET HAS NOT LIKES");
        
        tweets[author][id].likes--;
    }

    function getTweet(uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets() public  view returns (Tweet[] memory) {
        return tweets[msg.sender];
    }

}