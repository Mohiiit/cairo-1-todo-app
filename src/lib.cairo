use starknet::ContractAddress;
use ToDoApp::Task;
use alexandria_storage::list::{List, ListTrait};

use alexandria_data_structures::queue;

mod tests;

#[starknet::interface]
trait IToDoApp<TContractState> {
    // fn new(ref self: TContractState, description: felt252, status: felt252) -> Task;
    // fn get(self: @TContractState) -> Task;
    // fn set_description(ref self: TContractState, description: felt252);
    // fn set_status(ref self: TContractState, status: felt252) -> Task;

    fn add_task(ref self: TContractState, description: felt252, status: felt252) -> bool;
    fn get_task(self: @TContractState, id: u128) -> Task;
    // fn get_all_tasks(self: @TContractState) -> Array<Task>;
    // fn update_task_description(ref self: TContractState, description: felt252, id: u128) -> bool;
    // fn update_task_status(ref self: TContractState, status: felt252, id: u128) -> bool;
    // fn delete_task(ref self: TContractState, id: u128) -> bool;
}

#[starknet::contract]
mod ToDoApp {
    use starknet::{ContractAddress, get_caller_address};
    use alexandria_storage::list::{List, ListTrait};

    #[storage]
    struct Storage {
        id: u128,
        tasks: LegacyMap<u128, Task>,
        users: LegacyMap<ContractAddress, List<u128>>
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Task {
        owner: ContractAddress,
        description: felt252,
        status: felt252
    }

    #[external(v0)]
    impl ToDoApp of super::IToDoApp<ContractState>{

        // fn new(ref self: ContractState, description: felt252, status: felt252) -> Task {
        //     let task = Task {description, status};
        //     self.task.write(task);
        //     task
        // }

        // fn get(self: @ContractState) -> Task {
        //     self.task.read()
        // }

        // fn set_description(ref self: ContractState, description: felt252) {
        //     let curr_task = self.task.read();
        //     let status = curr_task.status;
        //     let new_task = Task {description, status};
        //     self.task.write(new_task);
        // }

        // fn set_status(ref self: ContractState, status: felt252) -> Task {
        //     let curr_task = self.task.read();
        //     let description = curr_task.description;
        //     let new_task = Task {description, status};
        //     self.task.write(new_task);
        //     new_task
        // }

        fn add_task(ref self: ContractState, description: felt252, status: felt252) -> bool {
            let owner = get_caller_address();
            let new_task = Task {owner, description, status};
            let mut curr_id = self.id.read() + 1;
            self.id.write(curr_id);
            self.tasks.write(curr_id, new_task);
            let mut users = self.users.read(owner);
            let new_entry = users.append(curr_id);
            self.users.write(owner, users);
            true
        }
        fn get_task(self: @ContractState, id: u128) -> Task {
            self.tasks.read(id)
        }
        // fn get_all_tasks(self: @ContractState) -> Array<Task>;
        // fn update_task_description(ref self: ContractState, description: felt252, id: u128) -> bool;
        // fn update_task_status(ref self: ContractState, status: felt252, id: u128) -> bool;
        
    }
}
