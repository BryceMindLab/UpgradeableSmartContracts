pragma solidity ^0.4.24;

/// @title Property Access Control 
/// @author Adapted from: Axiom Zen (https://www.axiomzen.co)
contract PropertyAccessControl {
    // This facet controls access control for CryptoCrests. There are four roles managed here:
    //
    //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
    //         contracts. It is also the only role that can unpause the smart contract. It is initially
    //         set to the address that created the smart contract in the
    //
    //     - The CFO: The CFO can withdraw funds from the contract.
    //
    //     - The COO: The COO .
    //
    // It should be NOTE:  that these roles are distinct without overlap in their access abilities, the
    // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
    // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
    // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
    // convenience. The less we use an address, the less likely it is that we somehow compromise the
    // account.

    event Paused(bool paused);

    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public CEOAddress;
    address public CFOAddress;
    address public COOAddress;

    // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
    bool public isCEOPaused = false;
    bool public isPaused = false;

    /// @dev The CrestAccessControl constructor sets the original sender of the contract as the CEO
    constructor() public {
        CEOAddress = msg.sender;
    }

    /*

    Function Modifiers 

    */

    /// @dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(
            msg.sender == CEOAddress,
            "You must be the CEO to perform this action."
        );
        _;
    }

    /// @dev Access modifier for CFO-only functionality
    modifier onlyCFO() {
        require(
            msg.sender == CFOAddress,
            "You must be the CFO to perform this action."    
        );
        _;
    }

    /// @dev Access modifier for COO-only functionality
    modifier onlyCOO() {
        require(
            msg.sender == COOAddress,
            "You must be the COO to perform this action."    
        );
        _;
    }

    modifier onlyCLevel() {
        require(
            msg.sender == CEOAddress ||
            msg.sender == CFOAddress ||
            msg.sender == COOAddress,
            "You must be a company officer to perform this action."
        );
        _;
    }

    /*

    External Setters 
    
    */

    /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    /// @param _newCEO The address of the new CEO
    function setCEO(address _newCEO) external onlyCEO {
        require(
            _newCEO != address(0),
            "You are attempting to set the new CEO to address(0)."
        );
        CEOAddress = _newCEO; 
    }

    /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
    /// @param _newCFO The address of the new CFO
    function setCFO(address _newCFO) external onlyCEO {
        require(
            _newCFO != address(0),
            "You are attempting to set the new CFO to address(0)."   
        );
        CFOAddress = _newCFO;
    }

    /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
    /// @param _newCOO The address of the new COO
    function setCOO(address _newCOO) external onlyCEO {
        require(
            _newCOO != address(0),
            "You are attempting to set the new COO to address(0)."    
        );
        COOAddress = _newCOO;
    }


    /*

    Pause Functionality  

    */

    /*** Pausable functionality adapted from OpenZeppelin ***/
    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(
            isPaused && !isCEOPaused,
            "Cannot perform this action while contract is paused."    
        );
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused(bool _excludingCEOPause) {
        if(_excludingCEOPause) {
            require(
                isPaused,
                "Cannot perform action because the app needs to be 'paused' (not counting CEOPaused)." 
            );
        } else {
            require(
                isPaused || isCEOPaused,
                "Cannot perform this action because the contract is not paused."
            );
        }
        _;
    }

    /// @dev A CEO pause option that only they can unpause. 
    function pauseCEO() external onlyCEO whenNotPaused {
        isCEOPaused = true; 
        emit Paused(isPaused || isCEOPaused);
    }

    /// @dev Unpauses the smart contract. Can only be called by the CEO, since
    //  one reason we may pause the contract is when CFO or COO accounts are
    //  compromised.
    /// @notice This is public rather than external so it can be called by
    //  derived contracts.
    function unpauseCEO() external onlyCEO whenPaused(false) {
        isPaused = false;
        isCEOPaused = false; 
        emit Paused(isPaused || isCEOPaused);
    }

    /// @dev When calculating faction payouts the contract will be paused to
    // 	ensure no data is updated during the payout session.
    function pause() public onlyCLevel whenNotPaused {
        isPaused = true;
        emit Paused(isPaused || isCEOPaused);
    }

    /// @dev After the factions are paid the contract will resume operation.
    function unpause() public onlyCLevel whenPaused(true) {
        isPaused = false; 
        emit Paused(isPaused || isCEOPaused);
    }


}
