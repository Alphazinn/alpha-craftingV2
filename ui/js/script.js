// Variables
var CurrentItem = undefined;
var UserInventory = undefined;
var LevelData = undefined;
var InMenu = false;
var CountdownTimer = undefined;
var IsCrafting = false;
var TempMaxXP = undefined;

var CompletedSound = document.createElement("audio");
CompletedSound.setAttribute("src", "../../assets/sfx/completed.wav");

var FailedSound = document.createElement("audio");
FailedSound.setAttribute("src", "../../assets/sfx/failed.wav");

var ClickSound = document.createElement("audio");
ClickSound.setAttribute("src", "../../assets/sfx/clickitem.wav");

var CraftSound = document.createElement("audio");
CraftSound.setAttribute("src", "../../assets/sfx/craftbutton.wav");

// Functions
const OpenUI = (StationID) => {
    $(".Container").show(200);
    $.post("https://alpha-craftingV2/GetMenuData", JSON.stringify({ data: StationID }));
    $.post("https://alpha-craftingV2/GetPlayerInventory");
    $.post("https://alpha-craftingV2/GetLevelData");
    InMenu = true;
};

const CloseUI = () => {
    $(".Container").hide(200);
    $(".ItemRecipeContainer").hide(200);
    $(".CraftButton").hide(200);
    $(".LevelContainer").hide(200);
    $(".LevelContainerLevel").hide(200);
    $.post("https://alpha-craftingV2/CloseCSUI");
    InMenu = false;
    if (IsCrafting) {
        $.post("https://alpha-craftingV2/RefundItems");
    };
    IsCrafting = false;
    clearInterval(CountdownTimer);
};

const FilterTime = (data) => {
    var FilterTimeMinutes = Math.floor(data / 60);
    var FilterTimeSeconds = data - FilterTimeMinutes * 60;
    return `${FilterTimeMinutes.toString().length === 1 ? `0${FilterTimeMinutes}` : FilterTimeMinutes}:${FilterTimeSeconds.toString().length === 1 ? `0${FilterTimeSeconds}` : FilterTimeSeconds}`;
};

const GetItemAmount = (data) => {
    var ItemAmount = 0;

    var UserInventoryAsArray = Object.keys(UserInventory).map((key) => [Number(key), UserInventory[key]]);

    for (let zort = 0; zort < UserInventoryAsArray.length; zort++) {
        if (UserInventoryAsArray[zort][1] !== null) {
            if (UserInventoryAsArray[zort][1].name === data) {
                ItemAmount += UserInventoryAsArray[zort][1].amount;
            };
        };
    };

    return ItemAmount;
};

const UpdateCurrentItem = (data) => {
    CurrentItem = data;
};

const UpdateLevelArea = (data, dataTwo) => {
    var ResultAnim = Math.round((100 * data) / TempMaxXP);
    if (dataTwo) {
        $(".LevelContainerLevel").html(`Level ${dataTwo}`);
    };
    if (data) {
        $(".LevelContainerInner").animate({ width: ResultAnim.toString() + "%" }, 500, "easeOutCirc");
    };
};

const CraftItem = (data) => {
    if (IsCrafting === false) {
        if (!data || data === undefined) {
            // Alert User, There's Has Been Error!
        } else {
            $.post("https://alpha-craftingV2/CheckCraft", JSON.stringify({ data: data.toUpperCase() }));
        };
    };
};

const UpdateRequirementsArea = () => {
    var RecipeRequirementsArea = document.getElementsByClassName("ItemRecipeRequirements");
    var SizeOfRecipe = RecipeRequirementsArea[0].getElementsByTagName("div").length;
    for (let AlphaD = 1; AlphaD <= SizeOfRecipe; AlphaD++) {
        var NeededQ = $(`.NeededQuantity${AlphaD}`).text();
        var NeededQu = parseInt(NeededQ.slice(1));

        var UserItemQ = $(`.UserItemQuantity${AlphaD}`).text();
        var UserItemQu = parseInt(UserItemQ.slice(1));

        $(`.UserItemQuantity${AlphaD}`).html(`x${UserItemQu - NeededQu}`);
    };
};

const StartCraftItem = (data) => {
    if (IsCrafting === false) {
        $.post("https://alpha-craftingV2/TakeItemsFromPlayer", JSON.stringify({ data: data.Requirements }));
        UpdateRequirementsArea();
        $(`#${data.Item}`).effect("shake", {times: 2}, 200);
        CountdownTimer = setInterval(() => {
            if (InMenu === true) {
                IsCrafting = true;
                $(".CraftButton").css("cursor", "not-allowed");
                var GetTime = $(`#${data.Item}`).text();
                var SplittedTime = GetTime.split(":");
                var Minutes = SplittedTime[0];
                var Seconds = SplittedTime[1];

                if (Minutes <= 0 && Seconds <= 0) {
                    clearInterval(CountdownTimer);
                    IsCrafting = false;
                    TimerState = false;
                    $(`#${data.Item}`).html(FilterTime(data.Time));
                    $(".CraftButton").css("cursor", "pointer");
                    $.post("https://alpha-craftingV2/GiveItemToPlayer", JSON.stringify({ data: data, TempMaxXP }));
                } else if (Minutes > 0 && Seconds <= 0) {
                    $(`#${data.Item}`).html(`${Minutes - 1}:59`);
                } else if (Seconds > 0) {
                    var FixSeconds = Seconds - 1;
                    $(`#${data.Item}`).html(`${Minutes}:${FixSeconds.toString().length >= 2 ? FixSeconds : `0${FixSeconds}`}`);
                };
            };
        }, 1000);
    };
};

const CreateMenuItems = (data) => {

    $(".Container").empty();

    for (let ContainerIndex = 0; ContainerIndex < data.Crafts.length; ContainerIndex++) {
        $(".Container").append(`
            <div class="ItemContainer" onclick="UpdateCurrentItem('${data.Crafts[ContainerIndex].Item}')">
                <div class="ItemLabel">${data.Crafts[ContainerIndex].Label}</div>
                <div class="ItemImage"><img src="${data.Crafts[ContainerIndex].Icon}"></div>
            </div>
        `);
    };

    // After Create Items

    $(".ItemContainer").mouseover(function() {
        const obj = $(this);
        if (obj.attr("id") != "clicked") {
            obj.css("background-color", "rgb(197, 56, 56)");
            obj.css("transform", "scale(1.03)");
        };
    });

    $(".ItemContainer").mouseout(function() {
        const obj = $(this);
        if (obj.attr("id") != "clicked") {
            obj.css("background-color", "rgba(240, 248, 255, 0.15)");
            obj.css("transform", "scale(1)");
        };
    });

    $(".ItemContainer").click(function() {
        const obj = $(this);

        if (obj.attr("id") != "clicked") {
            ClickSound.play();
        };

        const prevObj = $("#clicked");
        prevObj.removeAttr("id");
        prevObj.css("background-color", "rgba(240, 248, 255, 0.15)");
        prevObj.css("transform", "scale(1)");

        obj.attr("id", "clicked");
        obj.css("background-color", "rgb(197, 56, 56)");
        obj.css("transform", "scale(1.03)");

        $(".ItemRecipeContainer").empty();
        $(".ItemRecipeContainer").fadeIn(200);

        var CurrentItemData = undefined;
        for (let ItemIndex = 0; ItemIndex < data.Crafts.length; ItemIndex++) {
            if (data.Crafts[ItemIndex].Item === CurrentItem) {
                CurrentItemData = data.Crafts[ItemIndex];
            };
        };

        $(".ItemRecipeContainer").append(`
            <div class="ItemRecipeCraftingTime"><i class="fa-solid fa-stopwatch"></i> ${FilterTime(CurrentItemData.Time)}</div>
            <div class="ItemRecipeSuccessRate"><i class="fa-solid fa-percent"></i> ${CurrentItemData.SuccessRate}</div>
            <div class="ItemRecipeNeededLevel"><i class="fa-solid fa-wand-magic-sparkles"></i> ${CurrentItemData.Level}</div>
            <div class="ItemRecipeQuantity"><i class="fa-solid fa-hand-holding-hand"></i> ${CurrentItemData.Quantity}</div>

            <div class="ItemRecipeName">${CurrentItemData.Label.length > 25 ? CurrentItemData.Label.substring(0, 25) + "..." : CurrentItemData.Label}</div>
            <div class="ItemRecipeIcon"><img src="${CurrentItemData.Icon}"></div>
            <div class="ItemRecipeDescription">${CurrentItemData.Description}</div>
            <hr>
            <h2>Requirements</h2>
            <div class="CountdownTimer" id="${CurrentItemData.Item}">${FilterTime(CurrentItemData.Time)}</div>
            <div class="ItemRecipeRequirements">

            </div>
        `);

        for (let RequirementsIndex = 0; RequirementsIndex < CurrentItemData.Requirements.length; RequirementsIndex++) {
            $(".ItemRecipeRequirements").append(`
                <div id=AlphaRecipeRequirement${RequirementsIndex + 1} class="ItemRecipeRequirement"><img src="${CurrentItemData.Requirements[RequirementsIndex].Icon}"> <p>${CurrentItemData.Requirements[RequirementsIndex].Label} <strong class=NeededQuantity${RequirementsIndex + 1}>x${CurrentItemData.Requirements[RequirementsIndex].Amount}</strong> (<strong class=UserItemQuantity${RequirementsIndex + 1}>x${GetItemAmount(CurrentItemData.Requirements[RequirementsIndex].ItemName)}</strong>)</p></div>
            `);
        };

        if (IsCrafting) {
            UpdateRequirementsArea();
        };

        $(".CraftButton").remove();
        $(".ItemRecipeContainer").after(`
            <div class="CraftButton DisableSelection" onclick="CraftItem('${CurrentItemData.Item}:${CurrentItemData.Category}')"><i class="fa-solid fa-pen-ruler"></i> Craft <strong>${CurrentItemData.Label.toUpperCase()}</strong></div>
        `);

        $(".CraftButton").fadeIn(200);

        $(".CraftButton").mouseover(function() {
            if (IsCrafting === false) {
                $(this).css("background-color", "rgb(165, 36, 36)");
            };
        });

        $(".CraftButton").mouseout(function() {
            $(this).css("background-color", "rgb(197, 56, 56)");
        });

        $(".CraftButton").click(function() {
            if (IsCrafting === false) {
                CraftSound.play();
            };
        });

        if (LevelData[0]) {
            if (LevelData[1] === 30) {
                ResultAnim = 100;
            } else {
                var MaxXP = (Math.round(100 * LevelData[3].XPMultiplier)) * LevelData[1]
                var ResultAnim = Math.round((100 * LevelData[2]) / MaxXP);
                TempMaxXP = MaxXP;
            };

            $(".LevelContainer").fadeIn(200);
            $(".LevelContainerLevel").html(`Level ${LevelData[1]}`);
            $(".LevelContainerLevel").fadeIn(200);
            $(".LevelContainerInner").fadeIn(200);
            $(".LevelContainerInner").animate({ width: ResultAnim.toString() + "%" }, 500, "easeOutCirc");
        };

    });
};

// Events
$(document).ready(function() {
    window.addEventListener("message", function(event) {
        var eventData = event.data;
        if (eventData.action == "OpenCraftingStation") {
            OpenUI(typeof eventData.data === "string" ? eventData.data : eventData.data[1]);
        } else if (eventData.action == "SetMenuData") {
            CreateMenuItems(eventData.data);
        } else if (eventData.action == "SetUserInventory") {
            UserInventory = eventData.data;
        } else if (eventData.action == "SetLevelData") {
            LevelData = eventData.data;
        } else if (eventData.action == "StartCraftItem") {
            StartCraftItem(eventData.data);
            IsCrafting = true;
        } else if (eventData.action == "PlayCraftSFX") {
            if (eventData.data === "success") {
                CompletedSound.play();
            } else {
                FailedSound.play();
            };
        } else if (eventData.action == "UpdateLevelArea") {
            UpdateLevelArea(eventData.data[0], eventData.data[1])
        };
    });
});

$(document).on("keydown", function() {
    switch(event.keyCode) {
        case 27:
            CloseUI();
        break;
    }
});
