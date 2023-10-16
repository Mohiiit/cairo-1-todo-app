use cairo_1_to_do_app::ToDoApp;
use cairo_1_to_do_app::IToDoAppDispatcher;
use cairo_1_to_do_app::IToDoAppDispatcherTrait;

#[cfg(test)]
mod test {
    use starknet::ContractAddress;
    use super::ToDoApp;
    use super::IToDoAppDispatcher;
    use super::IToDoAppDispatcherTrait;
    use starknet::syscalls::deploy_syscall;
    use debug::PrintTrait;


    #[test]
    #[available_gas(2000000)]
    fn test_new_function() {
        let dispatcher = deploy_contract();
        let contract_data = dispatcher.new('testingDescription', 'testingStatus');
        let description = 'testingDescription';
        let completed = 'testingStatus';
        assert(contract_data.description==description, 'the description should be equal');
        assert(contract_data.completed==completed, 'the completed should be equal');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_get_function() {
        let dispatcher = deploy_contract();
        dispatcher.new('testingDescription', 'testingStatus');
        let contract_data = dispatcher.get();
        assert(contract_data.description=='testingDescription', 'the description should be equal');
        assert(contract_data.completed=='testingStatus', 'the completed should be equal');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_set_description_function() {
        let dispatcher = deploy_contract();
        dispatcher.new('testingDescription', 'testingStatus');
        dispatcher.set_description('testingSetDescription');
        let contract_data = dispatcher.get();
        assert(contract_data.description=='testingSetDescription', 'the description should be equal');
        assert(contract_data.completed=='testingStatus', 'the completed should be equal');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_set_status_function() {
        let dispatcher = deploy_contract();
        dispatcher.new('testingDescription', 'testingStatus');
        dispatcher.set_status('testingSetStatus');
        let contract_data = dispatcher.get();
        assert(contract_data.description=='testingDescription', 'the description should be equal');
        assert(contract_data.completed=='testingSetStatus', 'the completed should be equal');
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