// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

contract EscrowUpgradeable is Initializable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    struct Deal {
        address creator;
        address payer;
        address token;
        uint256 cost;
        uint256 commission;
        bool paid;
        bool released;
    }

    uint256 public commissionPercent; // 250 = 2.5%
    address public withdrawWallet;
    uint256 public nextDealId;

    mapping(uint256 => Deal) public deals;
    mapping(address => bool) public allowedTokens;
    mapping(address => uint256[]) public createdDeals;
    mapping(address => uint256[]) public paidDeals;
    mapping(address => uint256[]) public releasedDeals;

    event DealCreated(
        address indexed creator,
        address indexed token,
        uint256 cost,
        uint256 commissionPercent,
        uint256 commissionAmount,
        uint256 indexed dealId
    );

    event DealPaid(
        uint256 indexed dealId,
        address indexed payer,
        uint256 amount
    );

    event DealReleased(
        uint256 indexed dealId,
        address indexed to
    );

    function initialize() public initializer {
        __Ownable_init();
        __ReentrancyGuard_init();
    }

    // --- Admin functions ---
    function setWithdrawWallet(address _wallet) external onlyOwner {
        withdrawWallet = _wallet;
    }

    function setCommissionPercent(uint256 _percent) external onlyOwner {
        commissionPercent = _percent;
    }

    function addAllowedToken(address _token) external onlyOwner {
        allowedTokens[_token] = true;
    }

    // --- Core Logic ---
    function createDeal(address _token, uint256 _cost) external {
        require(allowedTokens[_token], "Token not allowed");

        uint256 commission = (_cost * commissionPercent) / 10000;
        uint256 halfCommission = commission / 2;

        IERC20Upgradeable(_token).transferFrom(msg.sender, address(this), halfCommission);

        Deal storage deal = deals[nextDealId];
        deal.creator = msg.sender;
        deal.token = _token;
        deal.cost = _cost;
        deal.commission = commission;

        createdDeals[msg.sender].push(nextDealId);

        emit DealCreated(msg.sender, _token, _cost, commissionPercent, commission, nextDealId);
        nextDealId++;
    }

    function payDeal(uint256 _dealId) external nonReentrant {
        Deal storage deal = deals[_dealId];
        require(!deal.paid, "Already paid");
        require(!deal.released, "Already released");

        uint256 total = deal.cost + (deal.commission / 2);
        IERC20Upgradeable(deal.token).transferFrom(msg.sender, address(this), total);

        deal.paid = true;
        deal.payer = msg.sender;
        paidDeals[msg.sender].push(_dealId);

        emit DealPaid(_dealId, msg.sender, total);
    }

    function releaseDeal(uint256 _dealId) external nonReentrant {
        Deal storage deal = deals[_dealId];
        require(deal.paid, "Not paid yet");
        require(!deal.released, "Already released");
        require(msg.sender == deal.payer, "Only payer can release");

        deal.released = true;
        releasedDeals[msg.sender].push(_dealId);

        IERC20Upgradeable(deal.token).transfer(deal.creator, deal.cost);

        emit DealReleased(_dealId, deal.creator);
    }

    // --- Getters ---
    function getDeal(uint256 _dealId) external view returns (Deal memory) {
        return deals[_dealId];
    }

    function getCreatedDeals(address _user) external view returns (uint256[] memory) {
        return createdDeals[_user];
    }

    function getPaidDeals(address _user) external view returns (uint256[] memory) {
        return paidDeals[_user];
    }

    function getReleasedDeals(address _user) external view returns (uint256[] memory) {
        return releasedDeals[_user];
    }

    // --- Withdrawal ---
    function withdrawTokens(address _token) external nonReentrant {
        require(msg.sender == withdrawWallet, "Not authorized");
        uint256 balance = IERC20Upgradeable(_token).balanceOf(address(this));
        IERC20Upgradeable(_token).transfer(msg.sender, balance);
    }
}
