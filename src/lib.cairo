use starknet::ContractAddress;
use ToDoApp::Task;

#[starknet::interface]
trait IToDoApp<TContractState> {
    fn new(ref self: TContractState, description: felt252, completed: felt252) -> Task;
    fn get(self: @TContractState) -> Task;
    fn set_description(ref self: TContractState, description: felt252);
    fn set_status(ref self: TContractState, completed: felt252) -> Task;
}



#[starknet::contract]
mod ToDoApp {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        task: Task
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Task {
        description: felt252,
        completed: felt252
    }


    #[external(v0)]
    impl ToDoApp of super::IToDoApp<ContractState>{

        fn new(ref self: ContractState, description: felt252, completed: felt252) -> Task {
            let task = Task {description, completed};
            self.task.write(task);
            task
        }

        fn get(self: @ContractState) -> Task {
            self.task.read()
        }

        fn set_description(ref self: ContractState, description: felt252) {
            let curr_task = self.task.read();
            let completed = curr_task.completed;
            let new_task = Task {description, completed};
            self.task.write(new_task);
        }

        fn set_status(ref self: ContractState, completed: felt252) -> Task {
            let curr_task = self.task.read();
            let description = curr_task.description;
            let new_task = Task {description, completed};
            self.task.write(new_task);
            new_task
        }
        
    }
}
