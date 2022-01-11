// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract DocumentTracking {

    struct DocumentContent {
        string hash;
    }

    struct Document {
        uint32 id;
        uint8 latestVersion;
        mapping(uint8  => DocumentContent) versions;
    }

    mapping(uint32 => Document) documents;

    modifier positiveDocId(uint32 id) {
        require(id > 0);
        _;
    }

    function getDocumentLatestVersion(uint32 id) view public positiveDocId(id) returns(uint32) {
        return documents[id].latestVersion;
    }

    function getDocumentLatestVersionAndHash(uint32 id) view public positiveDocId(id) returns(string memory, uint8) {
        return (documents[id].versions[documents[id].latestVersion].hash,
            documents[id].latestVersion);
    }

    function getDocumentHash(uint32 id, uint8  version) view public positiveDocId(id) returns(string memory) {
        return documents[id].versions[version].hash;
    }

    function newDocument(uint32 id, string memory hash) public positiveDocId(id) {
        uint8 nextVersion = documents[id].latestVersion + 1;
        documents[id].latestVersion = nextVersion;

        DocumentContent memory docVersion;
        docVersion.hash = hash;

        documents[id].versions[nextVersion] = docVersion;
    }
    
}