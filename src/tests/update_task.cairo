use cairo_1_to_do_app::ToDoApp;
use cairo_1_to_do_app::IToDoAppDispatcher;
use cairo_1_to_do_app::IToDoAppDispatcherTrait;

use starknet::{ContractAddress, get_caller_address};

use cairo_1_to_do_app::tests::utils::deploy_contract;

#[test]
#[available_gas(2000000)]
fn test_update_task_description_function() {
    let dispatcher = deploy_contract();
    let curr_caller = get_caller_address();

    let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
    let contract_response = dispatcher.update_task_description('updatedDescription', 1);
    assert(contract_response == true, 'issue while updating the task');

    let contract_response = dispatcher.getTask(1);
    assert(contract_response.description == 'updatedDescription', 'issue in description');
    assert(contract_response.status == 'testingStatus', 'issue in status');
}
