use starknet::ContractAddress;
use ToDoApp::Task;
use alexandria_storage::list::{List, ListTrait};

use alexandria_data_structures::queue;

mod tests;

#[starknet::interface]
trait IToDoApp<TContractState> {
    fn addTask(ref self: TContractState, description: felt252, status: felt252) -> bool;
    fn getTask(self: @TContractState, id: u128) -> Task;
    fn get_all_tasks(self: @TContractState) -> Array<Task>;
    fn update_task_description(ref self: TContractState, description: felt252, id: u128) -> bool;
    fn update_task_status(ref self: TContractState, status: felt252, id: u128) -> bool;
    fn delete_task(ref self: TContractState, id: u128) -> bool;
}

#[starknet::contract]
mod ToDoApp {
    use core::array::ArrayTrait;
    use core::option::OptionTrait;
    use alexandria_data_structures::array_ext::ArrayTraitExt;
    use starknet::{ContractAddress, get_caller_address};
    use alexandria_storage::list::{List, ListTrait};
    use debug::PrintTrait;

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
    impl ToDoApp of super::IToDoApp<ContractState> {
        fn addTask(ref self: ContractState, description: felt252, status: felt252) -> bool {
            let owner = get_caller_address();
            let new_task = Task { owner, description, status };
            let mut curr_id = self.id.read() + 1;
            self.id.write(curr_id);
            self.tasks.write(curr_id, new_task);
            let mut users = self.users.read(owner);
            let new_entry = users.append(curr_id);
            self.users.write(owner, users);
            true
        }
        fn getTask(self: @ContractState, id: u128) -> Task {
            self.tasks.read(id)
        }
        fn get_all_tasks(self: @ContractState) -> Array<Task> {
            let owner = get_caller_address();
            let user_tasks_id: List<u128> = self.users.read(owner);
            let user_tasks_id_array: Array<u128> = user_tasks_id.array();
            let mut user_tasks_array = ArrayTrait::<Task>::new();
            let tasks_count = user_tasks_id.len();
            let mut curr_task_count = 0;
            loop {
                if curr_task_count == tasks_count {
                    break;
                }
                let curr_task_id = *user_tasks_id_array.at(curr_task_count);
                let curr_task = self.tasks.read(curr_task_id);
                user_tasks_array.append(curr_task);
                curr_task_count += 1;
            };
            user_tasks_array
        }
        fn update_task_description(
            ref self: ContractState, description: felt252, id: u128
        ) -> bool {
            let owner = get_caller_address();
            let user_tasks_id: List<u128> = self.users.read(owner);
            let user_tasks_id_array: Array<u128> = user_tasks_id.array();
            let task_owner = user_tasks_id_array.index_of(id);

            if (task_owner.is_some()) {
                let mut curr_task = self.tasks.read(id);
                curr_task.description = description;
                self.tasks.write(id, curr_task);
                return true;
            }
            false
        }
        fn update_task_status(ref self: ContractState, status: felt252, id: u128) -> bool {
            let owner = get_caller_address();
            let user_tasks_id: List<u128> = self.users.read(owner);
            let user_tasks_id_array: Array<u128> = user_tasks_id.array();
            let task_owner = user_tasks_id_array.index_of(id);

            if (task_owner.is_some()) {
                let mut curr_task = self.tasks.read(id);
                curr_task.status = status;
                self.tasks.write(id, curr_task);
                return true;
            }
            false
        }
        fn delete_task(ref self: ContractState, id: u128) -> bool {
            let owner = get_caller_address();
            let mut user_tasks_id: List<u128> = self.users.read(owner);
            let mut user_tasks_id_array: Array<u128> = user_tasks_id.array();
            let task_index_wrapped = user_tasks_id_array.index_of(id);

            if (task_index_wrapped.is_some()) {
                let task_index = task_index_wrapped.unwrap();
                user_tasks_id.set(task_index, 0);
                self.users.write(owner, user_tasks_id);
                return true;
            }
            false
        }
    }
}
