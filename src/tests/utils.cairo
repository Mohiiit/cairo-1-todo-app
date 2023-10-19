use starknet::syscalls::deploy_syscall;
use cairo_1_to_do_app::ToDoApp;
use cairo_1_to_do_app::IToDoAppDispatcher;
use cairo_1_to_do_app::IToDoAppDispatcherTrait;

fn deploy_contract() -> IToDoAppDispatcher {
    let mut calldata = ArrayTrait::new();
    let (address0, _) = deploy_syscall(
        ToDoApp::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    let contract0 = IToDoAppDispatcher { contract_address: address0 };
    contract0
}
