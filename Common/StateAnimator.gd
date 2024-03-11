extends AnimationTree
class_name StateAnimator


enum BlockState {
	None,
	Blocking,
	PerfectBlocking
}


func get_block_state() -> BlockState:
	return BlockState.None


func commit_block(state: BlockState):
	assert(state == 100)
