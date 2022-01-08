-- require("/disk/modules/React")
-- require("/disk/src/components/TaskBar/TaskBar")
-- require("/disk/src/context/UserContext")

App = function()
    local user,setUser = React.useState("bob")
    return UserContext:Provider({
        value=user,
        updater=setUser,
        children = TaskBar({setUser=setUser})
    })
end