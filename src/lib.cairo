#[starknet::interface]
trait IToDoApp<TContractState> {
    fn get_one(self: @TContractState, id: u128) -> bool;
}

#[starknet::contract]
mod ToDoApp {
    #[storage]
    struct Storage {
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
    }

}

