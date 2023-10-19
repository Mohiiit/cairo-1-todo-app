use cairo_1_to_do_app::ToDoApp;
use cairo_1_to_do_app::IToDoAppDispatcher;
use cairo_1_to_do_app::IToDoAppDispatcherTrait;

use starknet::{ContractAddress, get_caller_address};

use cairo_1_to_do_app::tests::utils::deploy_contract;

#[test]
#[available_gas(2000000)]
fn test_add_task_function() {
    let dispatcher = deploy_contract();

    let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
    assert(contract_response == true, 'issue while adding the task');
}
