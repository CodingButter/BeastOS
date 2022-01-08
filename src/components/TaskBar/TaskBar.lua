-- require("/disk/modules/React")
-- require("/disk/src/components/TaskBar/StartButton")
-- require("/disk/src/components/TaskBar/BeastOs")

e = React.Element.new

TaskBar = function(props)
    return e("div",{
        id = "taskbar",
        style = {
            height = 1,
            width = WIDTH,
            top = HEIGHT - 1,
            backgroundColor = cc.colors.red,
            textColor = cc.colors.black
        },
        children = {StartButton(),BeastOs()}
    })
end
