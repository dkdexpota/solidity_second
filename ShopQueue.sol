pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract ShopQueue {

	// State variable storing the sum of arguments that were passed to function 'add',
	string[] public queue;

	constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	// Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	function queuePush(string personName) public checkOwnerAndAccept {
		require(personName!="");
		queue.push(personName);
	}

	function queuePop() public checkOwnerAndAccept {
		require(!queue.empty(), 54);
		for (uint i = 0; i < queue.length-1; i++) {
			queue[i] = queue[i+1];
		}
		queue.pop();
	}
}
