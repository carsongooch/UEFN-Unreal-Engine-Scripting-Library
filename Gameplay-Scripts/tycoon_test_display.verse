using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/SpatialMath }

# Helper function: format float to one decimal, remove trailing zeros/decimal point
FormatFloat(Value:float):string =
    if (RoundedInt := Round[Value * 10.0]):
        RoundedValue := (RoundedInt * 1.0) / 10.0
        StrValue := ToString(RoundedValue)
        if (DecimalPos := StrValue.Find['.']):
            var AllZeros : logic = true
            for (Index := DecimalPos + 1..StrValue.Length - 1):
                if (StrValue[Index] <> '0'):
                    set AllZeros = false
            if (AllZeros?):
                if (Result := StrValue.Slice[0, DecimalPos]):
                    return Result
            if (StrValue.Length >= DecimalPos + 2):
                if (Result := StrValue.Slice[0, DecimalPos + 2]):
                    return Result
            return StrValue
        return StrValue
    return "0"

# Helper function to format money with suffixes, using smart float formatting
FormatMoney(Amount:int):string =
    if (Amount >= 1000000000):
        return "{FormatFloat(Amount * 0.000000001)}B"
    else if (Amount >= 1000000):
        return "{FormatFloat(Amount * 0.000001)}M"
    else if (Amount >= 1000):
        return "{FormatFloat(Amount * 0.001)}K"
    return "{Amount}"

tycoon_money_display := class(creative_device):
    @editable
    MoneyDisplay : billboard_device = billboard_device{}
    @editable
    DoubleEarningsTrigger : trigger_device = trigger_device{}
    @editable
    upgrade1 : creative_prop = creative_prop{}
    @editable
    upgrade2 : creative_prop = creative_prop{}
    @editable
    upgrade3 : animated_mesh_device = animated_mesh_device{}

    var Money : int = 0
    var MoneyPerTick : int = 25
    @editable UpdateInterval : float = 1.0
    var CurrentModelIndex : int = 1

    var upgrade3Transform : transform = transform{}

    FormatMoneyMessage<localizes>(Text:string):message = "{Text}"

    OnBegin<override>()<suspends>:void =
        set upgrade3Transform = upgrade3.GetTransform()
        upgrade2.Hide()
        Hideupgrade3()
        DoubleEarningsTrigger.TriggeredEvent.Subscribe(OnDoubleEarningsTriggered)
        UpdateMoneyDisplay()
        loop:
            Sleep(UpdateInterval)
            set Money += MoneyPerTick
            UpdateMoneyDisplay()

    Hideupgrade3() : void =
        if (upgrade3.TeleportTo[vector3{X := 0.0, Y := 0.0, Z := -100000.0}, rotation{}]) {}

    Showupgrade3() : void =
        if (upgrade3.TeleportTo[upgrade3Transform.Translation, upgrade3Transform.Rotation]):
            upgrade3.Play()

    OnDoubleEarningsTriggered(Agent:?agent):void =
        if (CurrentModelIndex = 1):
            set MoneyPerTick = 2000
            upgrade1.Hide()
            upgrade2.Show()
            set CurrentModelIndex = 2
        else if (CurrentModelIndex = 2):
            set MoneyPerTick = 100000
            upgrade2.Hide()
            Showupgrade3()
            set CurrentModelIndex = 3
            DoubleEarningsTrigger.Disable()

    UpdateMoneyDisplay():void =
        MoneyDisplay.SetText(FormatMoneyMessage("Money: {FormatMoney(Money)}"))
        MoneyDisplay.UpdateDisplay()
