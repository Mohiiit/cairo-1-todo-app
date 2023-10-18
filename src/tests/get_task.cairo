use cairo_1_to_do_app::ToDoApp;
use cairo_1_to_do_app::IToDoAppDispatcher;
use cairo_1_to_do_app::IToDoAppDispatcherTrait;

use starknet::{ContractAddress, get_caller_address};

use cairo_1_to_do_app::tests::utils::deploy_contract;


#[test]
#[available_gas(2000000)]
fn test_get_task_function() {
    let dispatcher = deploy_contract();
    let curr_caller = get_caller_address();

    let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
    assert(contract_response == true, 'issue while adding the task');

    let contract_response = dispatcher.getTask(1);
    assert(contract_response.description == 'testingDescription', 'issue in description');
    assert(contract_response.status == 'testingStatus', 'issue in status');
}

#[test]
#[available_gas(2000000)]
fn test_get_all_tasks_function() {
    let dispatcher = deploy_contract();
    let curr_caller = get_caller_address();

    let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
    let contract_response = dispatcher.addTask('testingDescription23', 'testingStatus23');

    let contract_response: Array<ToDoApp::Task> = dispatcher.get_all_tasks();
    assert(contract_response.len() == 2, 'length should be 2');

    let task_1: ToDoApp::Task = *contract_response.at(0);
    assert(task_1.description == 'testingDescription', 'issue in description');
    assert(task_1.status == 'testingStatus', 'issue in status');

    let task_2: ToDoApp::Task = *contract_response.at(1);
    assert(task_2.description == 'testingDescription23', 'issue in description');
    assert(task_2.status == 'testingStatus23', 'issue in status');
}