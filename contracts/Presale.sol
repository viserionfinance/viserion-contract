// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b);
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface INetswapRouter {
    function factory() external pure returns (address);

    function Metis() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityMetis(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountMetisMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountMetis,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityMetis(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountMetisMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountMetis);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityMetisWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountMetisMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountMetis);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactMetisForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactMetis(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForMetis(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapMetisForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function removeLiquidityMetisSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountMetisMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountMetis);

    function removeLiquidityMetisWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountMetisMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountMetis);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactMetisForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForMetisSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external view returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external view returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface INetswapPair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

contract Presale is Context, Ownable {
    using SafeMath for uint256;

    struct Info {
        uint256 balances;
        bool whitelists;
        bool withdrawed;
        uint256 timesClaimes;
        uint256 lastTimeClaimed;
    }

    uint256 public tokenCap = 10e6 * 1e18;
    uint256 public tokenLp = 9e6 * 1e18;
    uint256 public maxIndividualCap = 1e17;
    uint256 public minIndividualCap = 1e16;
    uint256 public maxMetisCap = 1e17;
    uint256 public raisedTotal;

    IERC20 public token;

    uint256 public startTime;
    uint256 public endTime;

    uint256 public durationTime = 600;
    uint256 public lockTime;
    uint256 public lockDurationTime = 660;
    uint256 public waitTime = 1 days;
    // uint256 public lockDurationTime = 6 * 30 * 24 hours;

    bool public ended;
    bool public isDepositedTokenCap;
    bool public withdrawable;
    bool public isRefund;

    // mapping(address => uint256) public balances;
    // mapping(address => bool) public whitelists;
    // mapping(address => bool) public withdrawed;
    mapping(address => Info) public userInfo;

    INetswapRouter public netwapRoute;
    INetswapPair public pairToken;

    event ClaimLp(uint256 _amount);
    event Deposit();
    event EndPresale();
    event Claim(address indexed user, uint256 amount);
    event IDO(address indexed user, uint256 amount);

    constructor(
        address _token,
        address _pairToken,
        address _router
    ) public {
        token = IERC20(_token);
        netwapRoute = INetswapRouter(_router);
        pairToken = INetswapPair(_pairToken);
    }

    function startIdo() public onlyOwner {
        require(startTime == 0, "ido started");
        startTime = block.timestamp;
        endTime = startTime.add(durationTime);
    }

    function ido(uint256 _amount) external payable {
        require(userInfo[_msgSender()].whitelists, "Not in whitelist");
        require(startTime > 0, "PreSale is not started");
        require(maxMetisCap >= raisedTotal, "Sold out");
        require(endTime > block.timestamp, "PreSale is closed");
        require(
            _amount >= minIndividualCap ||
                maxMetisCap.sub(raisedTotal) < minIndividualCap,
            "Too small"
        );
        require(
            userInfo[_msgSender()].balances.add(_amount) <= maxIndividualCap,
            "Reach individual cap"
        );

        raisedTotal = raisedTotal.add(_amount);
        if (maxMetisCap < raisedTotal) {
            uint256 overCap = raisedTotal.sub(maxMetisCap);

            _amount = _amount.sub(overCap);
            raisedTotal = raisedTotal.sub(overCap);
        }

        address(this).call{value: _amount}("");
        userInfo[_msgSender()].balances += _amount;

        emit IDO(_msgSender(), _amount);
    }

    function deposit() external onlyOwner {
        require(!isDepositedTokenCap, "Deposited");
        token.transferFrom(_msgSender(), address(this), tokenCap.add(tokenLp));
        isDepositedTokenCap = true;
        emit Deposit();
    }

    function updateWhitelists(address[] memory _addresses, bool _status)
        external
        onlyOwner
    {
        for (uint256 index = 0; index < _addresses.length; index++) {
            userInfo[_addresses[index]].whitelists = _status;
        }
    }

    function endPresale() external onlyOwner {
        require(
            raisedTotal == maxMetisCap || endTime < block.timestamp,
            "Sale has not ended yet"
        );
        require(!ended, "Already ended");
        ended = true;

        if (raisedTotal > 0 && raisedTotal >= maxMetisCap.div(5).mul(3)) {
            require(isDepositedTokenCap, "Not deposited");
            uint256 devFund = raisedTotal.div(9);
            _msgSender().transfer(devFund);
            uint256 tokenAdd = tokenLp.mul(raisedTotal).div(maxMetisCap);
            if (tokenLp > tokenAdd) {
                token.transfer(
                    address(1),
                    tokenLp.sub((tokenAdd).div(5).mul(11))
                );
            }
            addLiquidity(tokenAdd, raisedTotal.sub(devFund));
        } else {
            isRefund = true;
        }

        endTime = block.timestamp;
        lockTime = block.timestamp.add(lockDurationTime);

        emit EndPresale();
    }

    function approveRouter() public {
        token.approve(address(netwapRoute), ~uint256(0));
    }

    function addLiquidity(uint256 _tokenAmount, uint256 _metisAmount) private {
        approveRouter();
        // add the liquidity
        netwapRoute.addLiquidityMetis{value: _metisAmount}(
            address(token),
            _tokenAmount,
            0,
            0,
            address(this),
            block.timestamp
        );
    }

    function safeEndPresale() external onlyOwner {
        token.transfer(_msgSender(), token.balanceOf(address(this)));
        _msgSender().transfer(address(this).balance);
    }

    function openWithdrawable() external onlyOwner {
        require(!withdrawable, "Withdrawable is enabled");
        withdrawable = true;
    }

    function claimLp() external onlyOwner {
        require(lockTime > 0 && lockTime < block.timestamp, "Invalid time.");

        uint256 lpBalance = pairToken.balanceOf(address(this));
        pairToken.transfer(_msgSender(), lpBalance);

        emit ClaimLp(lpBalance);
    }

    function setMaxIndividualCap(uint256 _amount) public onlyOwner {
        maxIndividualCap = _amount;
    }

    function setMinIndividualCap(uint256 _amount) public onlyOwner {
        minIndividualCap = _amount;
    }

    function setTokenCap(uint256 _amount) public onlyOwner {
        tokenCap = _amount;
    }

    function setMaxMetisCap(uint256 _amount) public onlyOwner {
        maxMetisCap = _amount;
    }

    function setWaitTime(uint256 _time) public onlyOwner {
        waitTime = _time;
    }

    function claimToken() external {
        require(ended, "Not ended");
        require(!userInfo[_msgSender()].withdrawed, "Withdrawed");
        require(withdrawable, "Withdrawal is not opened");
        require(isDepositedTokenCap, "Please wait admin deposit token");
        require(userInfo[_msgSender()].balances > 0, "Not join IDO");
        require(userInfo[_msgSender()].timesClaimes <= 5, "Max timesClaim");
        require(
            userInfo[_msgSender()].lastTimeClaimed + waitTime <
                block.timestamp ||
                userInfo[_msgSender()].lastTimeClaimed == 0,
            "wait to the nextTime"
        );
        if (isRefund) {
            _msgSender().transfer(userInfo[_msgSender()].balances);
        } else {
            uint256 idoAmount = (
                tokenCap
                    .mul(1e18)
                    .div(maxMetisCap)
                    .mul(userInfo[_msgSender()].balances)
                    .div(1e18)
            ).div(100).mul(20);

            token.transfer(_msgSender(), idoAmount);
            userInfo[_msgSender()].timesClaimes += 1;
            userInfo[_msgSender()].lastTimeClaimed = block.timestamp;
            if (userInfo[_msgSender()].timesClaimes >= 5) {
                userInfo[_msgSender()].withdrawed = true;
            }
        }

        emit Claim(_msgSender(), userInfo[_msgSender()].balances);
    }
}
