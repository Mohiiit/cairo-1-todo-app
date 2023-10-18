use cairo_1_to_do_app::ToDoApp;
use cairo_1_to_do_app::IToDoAppDispatcher;
use cairo_1_to_do_app::IToDoAppDispatcherTrait;

use starknet::{ContractAddress, get_caller_address};

use cairo_1_to_do_app::tests::utils::deploy_contract;

#[test]
#[available_gas(2000000)]
fn test_delete_task_function() {
    let dispatcher = deploy_contract();
    let curr_caller = get_caller_address();

    let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
    let contract_response = dispatcher.delete_task(1);
    assert(contract_response == true, 'issue while deleting the task');
}
