pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskBoard {

	struct task {
		string name;
		uint32 timestamp;
		bool status;
	}
	int8 lastTask = 0;
	int8 openTasks = 0;
	mapping(int8 => task) taskList;

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

	function addTask(string name) public checkOwnerAndAccept {
		require(name!="");
		lastTask++;
		taskList[lastTask] = task(name, now, false);
		openTasks++;
	}

	// Считает только задачи со статусом false, т. е. не выполненые, т. е. открытые
	function countOpenTasks() public checkOwnerAndAccept returns (int8) {
		return openTasks;
	}

	function getAllTasks() public checkOwnerAndAccept returns (mapping(int8 => task)) {
		return taskList;
	}

	function getTaskByKey(int8 taskNumber) public checkOwnerAndAccept returns (task) {
		require(taskList[taskNumber].name!="");
		return (taskList[taskNumber]);
	}

	function removeTaskByKey(int8 taskNumber) public checkOwnerAndAccept {
		require(taskList[taskNumber].name!="");
		if (!taskList[taskNumber].status) { openTasks--; }
		delete taskList[taskNumber];
	}

	function complitTaskByKey(int8 taskNumber) public checkOwnerAndAccept {
		require(taskList[taskNumber].name!="");
		taskList[taskNumber].status = true;
		openTasks--;
	}

}
