// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title RentBid
 * @dev Place a bid to rent an apartment from a landlord
 * @custom:dev-run-script ./scripts/rent_bid.ts
 */
contract RentBid {


    struct Bid {
        address bidder;
        uint256 amount;
    }

    address public landlord;
    uint256 public biddingEnd;
    uint256 public minimumBid;
    Bid public highestBid;

    mapping(address => uint256) public pendingReturns;
    bool public ended;

    event HighestBidIncreased(address bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    constructor(uint256 _biddingTime, uint256 _minimumBid) {
        landlord = msg.sender;
        biddingEnd = block.timestamp + _biddingTime;
        minimumBid = _minimumBid;
    }

    function bid() external payable {
        require(block.timestamp <= biddingEnd, "Bidding ended.");
        require(msg.value >= minimumBid, "Bid too low.");
        require(msg.value > highestBid.amount, "There already is a higher bid.");

        if (highestBid.amount != 0) {
            pendingReturns[highestBid.bidder] = highestBid.amount;
        }

        highestBid = Bid(msg.sender, msg.value);
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() external {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw.");
        pendingReturns[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function endAuction() external {
        require(block.timestamp >= biddingEnd, "Auction not yet ended.");
        require(!ended, "Auction already ended.");

        ended = true;
        emit AuctionEnded(highestBid.bidder, highestBid.amount);

        payable(landlord).transfer(highestBid.amount);
    }
}
