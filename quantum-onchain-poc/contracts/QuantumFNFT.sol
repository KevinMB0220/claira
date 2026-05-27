// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract QuantumFNFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    // Financial Architecture data matching the requested institutional layout
    struct FinancialSnapshot {
        string assetId;
        uint256 netOperatingIncome; // Stored as absolute value (USD)
        uint256 occupancyRate;      // e.g., 9500 for 95.00%
        uint256 dscr;               // Debt Service Coverage Ratio (e.g., 125 for 1.25x)
        uint256 cashflow;           // Current quarter cashflow (USD)
        uint256 lastVerifiedTimestamp;
    }

    // Mappings to hold data 100% on-chain
    mapping(uint256 => FinancialSnapshot) private _snapshots;

    // Events to allow tracking via blockchain logs
    event FinancialSnapshotUpdated(uint256 indexed tokenId, uint256 timestamp);

    constructor() ERC721("Quantum Financial NFT", "QFNFT") Ownable(msg.sender) {}

    /**
     * @notice Mints an FNFT and links it to its immutable legal structure and financial snapshot.
     */
    function mintInstitutionalFNFT(
        address investor,
        string memory tokenURIJson,
        string memory _assetId,
        uint256 _noi,
        uint256 _occupancy,
        uint256 _dscr,
        uint256 _cashflow
    ) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(investor, tokenId);
        _setTokenURI(tokenId, tokenURIJson);

        // Record metrics 100% on-chain
        _snapshots[tokenId] = FinancialSnapshot({
            assetId: _assetId,
            netOperatingIncome: _noi,
            occupancyRate: _occupancy,
            dscr: _dscr,
            cashflow: _cashflow,
            lastVerifiedTimestamp: block.timestamp
        });

        emit FinancialSnapshotUpdated(tokenId, block.timestamp);
        return tokenId;
    }

    /**
     * @notice External read function to query financial transparency directly from the nodes.
     */
    function getFinancialSnapshot(uint256 tokenId) public view returns (FinancialSnapshot memory) {
        _requireOwned(tokenId);
        return _snapshots[tokenId];
    }
}
