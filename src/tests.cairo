use cairo_1_to_do_app::ToDoApp;
use cairo_1_to_do_app::IToDoAppDispatcher;
use cairo_1_to_do_app::IToDoAppDispatcherTrait;

#[cfg(test)]
mod test {
    use starknet::{ContractAddress, get_caller_address};
    use super::ToDoApp;
    use super::IToDoAppDispatcher;
    use super::IToDoAppDispatcherTrait;
    use starknet::syscalls::deploy_syscall;
    use debug::PrintTrait;

    #[test]
    #[available_gas(2000000)]
    fn test_add_task_function() {
        let dispatcher = deploy_contract();
        let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
        assert(contract_response == true, 'issue while adding the task');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_get_task_function() {
        let dispatcher = deploy_contract();
        let curr_caller = get_caller_address();
        let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
        assert(contract_response == true, 'issue while adding the task');
        let contract_response = dispatcher.getTask(1);
        assert(contract_response.owner == curr_caller, 'issue in ownership');
        assert(contract_response.description == 'testingDescription', 'issue in description');
        assert(contract_response.status == 'testingStatus', 'issue in status');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_get_all_tasks_function() {
        let dispatcher = deploy_contract();
        let curr_caller = get_caller_address();

        let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
        assert(contract_response == true, 'issue while adding the task');

        let contract_response = dispatcher.addTask('testingDescription23', 'testingStatus23');
        assert(contract_response == true, 'issue while adding the task');

        let contract_response = dispatcher.getTask(1);
        assert(contract_response.owner == curr_caller, 'issue in ownership');
        assert(contract_response.description == 'testingDescription', 'issue in description');
        assert(contract_response.status == 'testingStatus', 'issue in status');

        let contract_response = dispatcher.getTask(2);
        assert(contract_response.owner == curr_caller, 'issue in ownership');
        assert(contract_response.description == 'testingDescription23', 'issue in description');
        assert(contract_response.status == 'testingStatus23', 'issue in status');

        let contract_response: Array<ToDoApp::Task> = dispatcher.get_all_tasks();
        assert(contract_response.len() == 2, 'length should be 2');

        let task_1: ToDoApp::Task = *contract_response.at(0);
        assert(task_1.owner == curr_caller, 'issue in ownership');
        assert(task_1.description == 'testingDescription', 'issue in description');
        assert(task_1.status == 'testingStatus', 'issue in status');

        let task_2: ToDoApp::Task = *contract_response.at(1);
        assert(task_2.owner == curr_caller, 'issue in ownership');
        assert(task_2.description == 'testingDescription23', 'issue in description');
        assert(task_2.status == 'testingStatus23', 'issue in status');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_update_task_description_function() {
        let dispatcher = deploy_contract();
        let curr_caller = get_caller_address();

        let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
        assert(contract_response == true, 'issue while adding the task');

        let contract_response = dispatcher.getTask(1);
        assert(contract_response.owner == curr_caller, 'issue in ownership');
        assert(contract_response.description == 'testingDescription', 'issue in description');
        assert(contract_response.status == 'testingStatus', 'issue in status');

        let contract_response = dispatcher.update_task_description('updatedDescription', 1);
        assert(contract_response == true, 'issue while updating the task');

        let contract_response = dispatcher.getTask(1);
        assert(contract_response.owner == curr_caller, 'issue in ownership');
        assert(contract_response.description == 'updatedDescription', 'issue in description');
        assert(contract_response.status == 'testingStatus', 'issue in status');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_update_task_status_function() {
        let dispatcher = deploy_contract();
        let curr_caller = get_caller_address();

        let contract_response = dispatcher.update_task_status('updatedStatus', 2);
        assert(contract_response == false, 'issue while updating the task');

        let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
        assert(contract_response == true, 'issue while adding the task');

        let contract_response = dispatcher.getTask(1);
        assert(contract_response.owner == curr_caller, 'issue in ownership');
        assert(contract_response.description == 'testingDescription', 'issue in description');
        assert(contract_response.status == 'testingStatus', 'issue in status');

        let contract_response = dispatcher.update_task_status('updatedStatus', 1);
        assert(contract_response == true, 'issue while updating the task');

        let contract_response = dispatcher.getTask(1);
        assert(contract_response.owner == curr_caller, 'issue in ownership');
        assert(contract_response.description == 'testingDescription', 'issue in description');
        assert(contract_response.status == 'updatedStatus', 'issue in status');

        let contract_response = dispatcher.update_task_status('updatedStatus', 2);
        assert(contract_response == false, 'issue while updating the task');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_delete_task_function() {
        let dispatcher = deploy_contract();
        let curr_caller = get_caller_address();

        let contract_response = dispatcher.delete_task(1);
        assert(contract_response == false, 'issue while deleting the task');

        let contract_response = dispatcher.addTask('testingDescription', 'testingStatus');
        assert(contract_response == true, 'issue while adding the task');

        let contract_response = dispatcher.getTask(1);
        assert(contract_response.owner == curr_caller, 'issue in ownership');
        assert(contract_response.description == 'testingDescription', 'issue in description');
        assert(contract_response.status == 'testingStatus', 'issue in status');

        let contract_response = dispatcher.delete_task(1);
        assert(contract_response == true, 'issue while deleting the task');

        let contract_response = dispatcher.delete_task(1);
        assert(contract_response == false, 'issue while deleting the task');
    }

    fn deploy_contract() -> IToDoAppDispatcher {
        let mut calldata = ArrayTrait::new();
        let (address0, _) = deploy_syscall(
            ToDoApp::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        let contract0 = IToDoAppDispatcher { contract_address: address0 };
        contract0
    }
}
