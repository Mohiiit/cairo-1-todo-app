# Cairo 1 ToDo Application

## Description

We are writing a todo smart contract using cairo 1.0 here which would have all the crud application along with tests.

## Prerequisites

Here is the list of the prerequisites and installation steps required before you can start working with the project. Here is the [link](https://github.com/Mohiiit/cairo-1-simple-storage#prerequisites).


## Smart Contract

Buisness logic can be found in the `lib.cairo` file. 

### Interface

Here is how the interface looks like:

```shell
#[starknet::interface]
trait IToDoApp<TContractState> {
    fn addTask(ref self: TContractState, description: felt252, status: felt252) -> bool;
    fn getTask(self: @TContractState, id: u128) -> Task;
    fn get_all_tasks(self: @TContractState) -> Array<Task>;
    fn update_task_description(ref self: TContractState, description: felt252, id: u128) -> bool;
    fn update_task_status(ref self: TContractState, status: felt252, id: u128) -> bool;
    fn delete_task(ref self: TContractState, id: u128) -> bool;
}
```



## Tests

Tests can be found in the `tests` directory.