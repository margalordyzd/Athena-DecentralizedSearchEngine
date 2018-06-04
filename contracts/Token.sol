import "./safemath.sol";
import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract WebValidation is MintableToken {
    string public name = "Athena";
    string public symbol = "ATN";
    uint8 public decimals = 18;
}
