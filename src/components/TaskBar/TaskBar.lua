-- require("/disk/modules/React")
-- require("/disk/src/components/TaskBar/StartButton")
-- require("/disk/src/components/TaskBar/BeastOs")
-- require("/disk/src/components/TaskBar/StartMenu")

e = React.Element.new

TaskBar = function(props)
    local menu,updateMenu = React.useState(false)

    local function toggleMenu()
        updateMenu(function(val)
            return val == false
        end)
    end

    local element =  e("div",{
        id = "taskbar",
        style = {
            height = 1,
            width = WIDTH,
            top = HEIGHT - 1,
            backgroundColor = cc.colors.red,
            textColor = cc.colors.black
        },
        children = {}
    })

    table.insert(element.props.children,StartButton({
        toggleMenu = toggleMenu
    }))
    if menu then table.insert(element.props.children,StartMenu()) end
    table.insert(element.props.children,BeastOs())

    return element
end
