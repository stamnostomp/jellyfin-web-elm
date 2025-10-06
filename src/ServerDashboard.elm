module ServerDashboard exposing (Model, Msg(..), init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Icon
import Theme



-- MODEL


type alias Model =
    { currentView : DashboardView
    , serverInfo : ServerInfo
    , activeUsers : List ActiveUser
    , libraries : List Library
    , scheduledTasks : List ScheduledTask
    , logs : List LogEntry
    , plugins : List Plugin
    }


type DashboardView
    = OverviewView
    | UsersView
    | LibrariesView
    | ScheduledTasksView
    | LogsView
    | PluginsView
    | NetworkingView
    | DevicesView


type alias ServerInfo =
    { version : String
    , operatingSystem : String
    , cpuUsage : Float
    , memoryUsage : Float
    , totalMemory : Float
    , uptime : String
    , activeStreams : Int
    , totalUsers : Int
    , totalLibraries : Int
    }


type alias ActiveUser =
    { username : String
    , deviceName : String
    , nowPlaying : Maybe String
    , playMethod : String
    , isActive : Bool
    }


type alias Library =
    { name : String
    , type_ : String
    , itemCount : Int
    , path : String
    , lastScan : String
    }


type alias ScheduledTask =
    { name : String
    , description : String
    , status : TaskStatus
    , lastRun : String
    , nextRun : String
    }


type TaskStatus
    = Idle
    | Running
    | Completed
    | Failed


type alias LogEntry =
    { timestamp : String
    , level : LogLevel
    , message : String
    , source : String
    }


type LogLevel
    = Info
    | Warning
    | Error
    | Debug


type alias Plugin =
    { name : String
    , version : String
    , description : String
    , author : String
    , isEnabled : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { currentView = OverviewView
      , serverInfo =
            { version = "10.8.13"
            , operatingSystem = "Linux"
            , cpuUsage = 15.5
            , memoryUsage = 2.4
            , totalMemory = 8.0
            , uptime = "5 days, 3 hours"
            , activeStreams = 2
            , totalUsers = 5
            , totalLibraries = 4
            }
      , activeUsers =
            [ { username = "User1", deviceName = "Chrome Browser", nowPlaying = Just "The Matrix", playMethod = "DirectPlay", isActive = True }
            , { username = "User2", deviceName = "Roku TV", nowPlaying = Just "Breaking Bad S01E01", playMethod = "Transcode", isActive = True }
            , { username = "User3", deviceName = "Android Phone", nowPlaying = Nothing, playMethod = "", isActive = False }
            ]
      , libraries =
            [ { name = "Movies", type_ = "movies", itemCount = 342, path = "/media/movies", lastScan = "2 hours ago" }
            , { name = "TV Shows", type_ = "tvshows", itemCount = 89, path = "/media/tv", lastScan = "1 day ago" }
            , { name = "Music", type_ = "music", itemCount = 1523, path = "/media/music", lastScan = "3 days ago" }
            , { name = "Photos", type_ = "photos", itemCount = 4521, path = "/media/photos", lastScan = "1 week ago" }
            ]
      , scheduledTasks =
            [ { name = "Library Scan", description = "Scan all libraries for new content", status = Idle, lastRun = "2 hours ago", nextRun = "In 4 hours" }
            , { name = "Backup Configuration", description = "Backup server configuration", status = Completed, lastRun = "1 day ago", nextRun = "Tomorrow" }
            , { name = "Clean Cache", description = "Clean temporary cache files", status = Idle, lastRun = "3 hours ago", nextRun = "In 21 hours" }
            ]
      , logs =
            [ { timestamp = "2025-10-06 14:32:15", level = Info, message = "Library scan completed successfully", source = "LibraryManager" }
            , { timestamp = "2025-10-06 14:28:03", level = Warning, message = "High CPU usage detected", source = "SystemMonitor" }
            , { timestamp = "2025-10-06 14:15:42", level = Error, message = "Failed to connect to metadata provider", source = "MetadataService" }
            , { timestamp = "2025-10-06 14:10:21", level = Info, message = "User 'Admin' logged in", source = "AuthenticationService" }
            ]
      , plugins =
            [ { name = "TMDb", version = "1.2.0", description = "The Movie Database metadata provider", author = "Jellyfin Team", isEnabled = True }
            , { name = "Trakt", version = "2.0.5", description = "Trakt.tv integration", author = "Community", isEnabled = True }
            , { name = "Fanart", version = "1.5.3", description = "Fanart.tv image provider", author = "Jellyfin Team", isEnabled = False }
            ]
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeView DashboardView
    | CloseDashboard
    | RefreshData
    | RunTask String
    | CancelTask String
    | TogglePlugin String
    | ScanLibrary String
    | RemoveLibrary String
    | KickUser String
    | ClearLogs


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeView newView ->
            ( { model | currentView = newView }, Cmd.none )

        CloseDashboard ->
            ( model, Cmd.none )

        RefreshData ->
            -- In real app, this would fetch fresh data from server
            ( model, Cmd.none )

        RunTask taskName ->
            -- In real app, this would trigger the scheduled task
            ( model, Cmd.none )

        CancelTask taskName ->
            -- In real app, this would cancel the running task
            ( model, Cmd.none )

        TogglePlugin pluginName ->
            let
                updatedPlugins =
                    List.map
                        (\plugin ->
                            if plugin.name == pluginName then
                                { plugin | isEnabled = not plugin.isEnabled }

                            else
                                plugin
                        )
                        model.plugins
            in
            ( { model | plugins = updatedPlugins }, Cmd.none )

        ScanLibrary libraryName ->
            -- In real app, this would trigger library scan
            ( model, Cmd.none )

        RemoveLibrary libraryName ->
            -- In real app, this would remove the library
            ( model, Cmd.none )

        KickUser username ->
            -- In real app, this would disconnect the user
            ( model, Cmd.none )

        ClearLogs ->
            ( { model | logs = [] }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "fixed inset-0 bg-background z-50 flex" ]
        [ viewSidebar model
        , viewMainContent model
        ]


viewSidebar : Model -> Html Msg
viewSidebar model =
    div [ class "w-64 bg-surface border-r border-background-light flex flex-col" ]
        [ div [ class "p-4 border-b border-background-light flex items-center justify-between" ]
            [ h2 (Theme.text Theme.Heading2 ++ [ class "text-primary" ])
                [ text "Dashboard" ]
            , button
                [ class "text-text-secondary hover:text-text-primary"
                , onClick CloseDashboard
                ]
                [ Icon.view [ class "text-2xl" ] Icon.close ]
            ]
        , div [ class "flex-1 overflow-y-auto py-2" ]
            [ viewSidebarItem model OverviewView "Overview" Icon.home
            , viewSidebarItem model UsersView "Active Users" Icon.person
            , viewSidebarItem model LibrariesView "Libraries" Icon.movie
            , viewSidebarItem model ScheduledTasksView "Scheduled Tasks" Icon.settings
            , viewSidebarItem model LogsView "Logs" Icon.search
            , viewSidebarItem model PluginsView "Plugins" Icon.settings
            , viewSidebarItem model NetworkingView "Networking" Icon.language
            , viewSidebarItem model DevicesView "Devices" Icon.tv
            ]
        , div [ class "p-4 border-t border-background-light" ]
            [ button
                (Theme.button Theme.Primary ++ [ class "w-full", onClick RefreshData ])
                [ text "Refresh Data" ]
            ]
        ]


viewSidebarItem : Model -> DashboardView -> String -> Icon.Icon -> Html Msg
viewSidebarItem model dashboardView label icon =
    let
        isActive =
            model.currentView == dashboardView

        baseClasses =
            "flex items-center space-x-3 px-4 py-3 cursor-pointer transition-colors"

        activeClasses =
            if isActive then
                " bg-primary bg-opacity-20 border-l-4 border-primary text-primary"

            else
                " hover:bg-background-light text-text-primary"
    in
    div
        [ class (baseClasses ++ activeClasses)
        , onClick (ChangeView dashboardView)
        ]
        [ Icon.view [ class "text-xl" ] icon
        , span (Theme.text Theme.Body) [ text label ]
        ]


viewMainContent : Model -> Html Msg
viewMainContent model =
    div [ class "flex-1 overflow-y-auto bg-background" ]
        [ div [ class "max-w-7xl mx-auto p-8" ]
            [ case model.currentView of
                OverviewView ->
                    viewOverview model

                UsersView ->
                    viewUsers model

                LibrariesView ->
                    viewLibraries model

                ScheduledTasksView ->
                    viewScheduledTasks model

                LogsView ->
                    viewLogs model

                PluginsView ->
                    viewPlugins model

                NetworkingView ->
                    viewNetworking model

                DevicesView ->
                    viewDevices model
            ]
        ]


viewOverview : Model -> Html Msg
viewOverview model =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Server Overview" ]
        , -- Stats cards
          div [ class "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4" ]
            [ viewStatCard "Active Streams" (String.fromInt model.serverInfo.activeStreams) Icon.playArrow "text-success"
            , viewStatCard "Total Users" (String.fromInt model.serverInfo.totalUsers) Icon.person "text-primary"
            , viewStatCard "Libraries" (String.fromInt model.serverInfo.totalLibraries) Icon.movie "text-warning"
            , viewStatCard "Uptime" model.serverInfo.uptime Icon.settings "text-secondary"
            ]
        , -- Server info
          div [ class "grid grid-cols-1 lg:grid-cols-2 gap-6" ]
            [ div [ class "bg-surface rounded-lg p-6" ]
                [ h2 (Theme.text Theme.Heading2 ++ [ class "mb-4" ])
                    [ text "System Information" ]
                , div [ class "space-y-3" ]
                    [ viewInfoRow "Version" model.serverInfo.version
                    , viewInfoRow "Operating System" model.serverInfo.operatingSystem
                    , viewInfoRow "CPU Usage" (String.fromFloat model.serverInfo.cpuUsage ++ "%")
                    , viewInfoRow "Memory Usage" (String.fromFloat model.serverInfo.memoryUsage ++ " GB / " ++ String.fromFloat model.serverInfo.totalMemory ++ " GB")
                    ]
                , div [ class "mt-4" ]
                    [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                        [ text ("CPU: " ++ String.fromFloat model.serverInfo.cpuUsage ++ "%") ]
                    , div [ class "w-full bg-background-light rounded-full h-2" ]
                        [ div
                            [ class "bg-primary h-2 rounded-full"
                            , style "width" (String.fromFloat model.serverInfo.cpuUsage ++ "%")
                            ]
                            []
                        ]
                    ]
                , div [ class "mt-4" ]
                    [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                        [ text ("Memory: " ++ String.fromFloat ((model.serverInfo.memoryUsage / model.serverInfo.totalMemory) * 100) ++ "%") ]
                    , div [ class "w-full bg-background-light rounded-full h-2" ]
                        [ div
                            [ class "bg-secondary h-2 rounded-full"
                            , style "width" (String.fromFloat ((model.serverInfo.memoryUsage / model.serverInfo.totalMemory) * 100) ++ "%")
                            ]
                            []
                        ]
                    ]
                ]
            , div [ class "bg-surface rounded-lg p-6" ]
                [ h2 (Theme.text Theme.Heading2 ++ [ class "mb-4" ])
                    [ text "Active Users" ]
                , div [ class "space-y-3" ]
                    (List.take 3 (List.map viewActiveUserRow model.activeUsers))
                ]
            ]
        ]


viewStatCard : String -> String -> Icon.Icon -> String -> Html Msg
viewStatCard label value icon colorClass =
    div [ class "bg-surface rounded-lg p-6" ]
        [ div [ class "flex items-center justify-between" ]
            [ div []
                [ p (Theme.text Theme.Caption ++ [ class "text-text-secondary mb-1" ])
                    [ text label ]
                , p (Theme.text Theme.Heading1 ++ [ class colorClass ])
                    [ text value ]
                ]
            , Icon.view [ class ("text-4xl " ++ colorClass) ] icon
            ]
        ]


viewInfoRow : String -> String -> Html Msg
viewInfoRow label value =
    div [ class "flex justify-between items-center" ]
        [ span (Theme.text Theme.Label)
            [ text label ]
        , span (Theme.text Theme.Body)
            [ text value ]
        ]


viewActiveUserRow : ActiveUser -> Html Msg
viewActiveUserRow user =
    div [ class "flex items-center justify-between p-3 bg-background rounded" ]
        [ div [ class "flex items-center space-x-3" ]
            [ div [ class "w-10 h-10 rounded-full bg-primary flex items-center justify-center text-white" ]
                [ text (String.left 1 user.username) ]
            , div []
                [ p (Theme.text Theme.Body ++ [ class "font-medium" ])
                    [ text user.username ]
                , p (Theme.text Theme.Caption ++ [ class "text-text-secondary" ])
                    [ text user.deviceName ]
                , case user.nowPlaying of
                    Just title ->
                        p (Theme.text Theme.Caption ++ [ class "text-primary" ])
                            [ text ("▶ " ++ title) ]

                    Nothing ->
                        text ""
                ]
            ]
        , if user.isActive then
            span [ class "px-2 py-1 bg-success bg-opacity-20 text-success rounded text-xs font-medium" ]
                [ text user.playMethod ]

          else
            span [ class "px-2 py-1 bg-background-light text-text-secondary rounded text-xs" ]
                [ text "Idle" ]
        ]


viewUsers : Model -> Html Msg
viewUsers model =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Active Users" ]
        , div [ class "bg-surface rounded-lg overflow-hidden" ]
            [ div [ class "overflow-x-auto" ]
                [ table [ class "w-full" ]
                    [ thead [ class "bg-background-light" ]
                        [ tr []
                            [ th [ class "px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider" ] [ text "User" ]
                            , th [ class "px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider" ] [ text "Device" ]
                            , th [ class "px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider" ] [ text "Now Playing" ]
                            , th [ class "px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider" ] [ text "Method" ]
                            , th [ class "px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider" ] [ text "Actions" ]
                            ]
                        ]
                    , tbody [ class "divide-y divide-background-light" ]
                        (List.map viewUserTableRow model.activeUsers)
                    ]
                ]
            ]
        ]


viewUserTableRow : ActiveUser -> Html Msg
viewUserTableRow user =
    tr [ class "hover:bg-background-light" ]
        [ td [ class "px-6 py-4 whitespace-nowrap" ]
            [ div [ class "flex items-center" ]
                [ div [ class "w-8 h-8 rounded-full bg-primary flex items-center justify-center text-white text-sm" ]
                    [ text (String.left 1 user.username) ]
                , span (Theme.text Theme.Body ++ [ class "ml-3 font-medium" ])
                    [ text user.username ]
                ]
            ]
        , td [ class "px-6 py-4 whitespace-nowrap" ]
            [ span (Theme.text Theme.Body)
                [ text user.deviceName ]
            ]
        , td [ class "px-6 py-4" ]
            [ case user.nowPlaying of
                Just title ->
                    span (Theme.text Theme.Body ++ [ class "text-primary" ])
                        [ text title ]

                Nothing ->
                    span (Theme.text Theme.Body ++ [ class "text-text-secondary" ])
                        [ text "—" ]
            ]
        , td [ class "px-6 py-4 whitespace-nowrap" ]
            [ if user.isActive then
                span [ class "px-2 py-1 bg-success bg-opacity-20 text-success rounded text-xs font-medium" ]
                    [ text user.playMethod ]

              else
                span [ class "px-2 py-1 bg-background-light text-text-secondary rounded text-xs" ]
                    [ text "Idle" ]
            ]
        , td [ class "px-6 py-4 whitespace-nowrap" ]
            [ button
                (Theme.button Theme.Ghost ++ [ class "text-error", onClick (KickUser user.username) ])
                [ text "Kick" ]
            ]
        ]


viewLibraries : Model -> Html Msg
viewLibraries model =
    div [ class "space-y-6" ]
        [ div [ class "flex items-center justify-between" ]
            [ h1 (Theme.text Theme.Heading1)
                [ text "Media Libraries" ]
            , button (Theme.button Theme.Primary)
                [ text "Add Library" ]
            ]
        , div [ class "grid grid-cols-1 md:grid-cols-2 gap-4" ]
            (List.map viewLibraryCard model.libraries)
        ]


viewLibraryCard : Library -> Html Msg
viewLibraryCard library =
    div [ class "bg-surface rounded-lg p-6" ]
        [ div [ class "flex items-start justify-between mb-4" ]
            [ div [ class "flex items-center space-x-3" ]
                [ Icon.view [ class "text-3xl text-primary" ]
                    (case library.type_ of
                        "movies" ->
                            Icon.movie

                        "tvshows" ->
                            Icon.tv

                        "music" ->
                            Icon.music

                        _ ->
                            Icon.movie
                    )
                , div []
                    [ h3 (Theme.text Theme.Heading3)
                        [ text library.name ]
                    , p (Theme.text Theme.Caption ++ [ class "text-text-secondary" ])
                        [ text (String.fromInt library.itemCount ++ " items") ]
                    ]
                ]
            ]
        , div [ class "space-y-2 mb-4" ]
            [ viewInfoRow "Path" library.path
            , viewInfoRow "Last Scan" library.lastScan
            ]
        , div [ class "flex space-x-2" ]
            [ button (Theme.button Theme.Primary ++ [ onClick (ScanLibrary library.name) ])
                [ text "Scan" ]
            , button (Theme.button Theme.Ghost)
                [ text "Edit" ]
            , button (Theme.button Theme.Ghost ++ [ class "text-error", onClick (RemoveLibrary library.name) ])
                [ text "Remove" ]
            ]
        ]


viewScheduledTasks : Model -> Html Msg
viewScheduledTasks model =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Scheduled Tasks" ]
        , div [ class "space-y-4" ]
            (List.map viewTaskCard model.scheduledTasks)
        ]


viewTaskCard : ScheduledTask -> Html Msg
viewTaskCard task =
    div [ class "bg-surface rounded-lg p-6" ]
        [ div [ class "flex items-start justify-between mb-3" ]
            [ div [ class "flex-1" ]
                [ h3 (Theme.text Theme.Heading3)
                    [ text task.name ]
                , p (Theme.text Theme.Body ++ [ class "text-text-secondary mt-1" ])
                    [ text task.description ]
                ]
            , viewTaskStatus task.status
            ]
        , div [ class "grid grid-cols-2 gap-4 mb-4" ]
            [ viewInfoRow "Last Run" task.lastRun
            , viewInfoRow "Next Run" task.nextRun
            ]
        , div [ class "flex space-x-2" ]
            [ if task.status == Running then
                button (Theme.button Theme.Secondary ++ [ onClick (CancelTask task.name) ])
                    [ text "Cancel" ]

              else
                button (Theme.button Theme.Primary ++ [ onClick (RunTask task.name) ])
                    [ text "Run Now" ]
            ]
        ]


viewTaskStatus : TaskStatus -> Html Msg
viewTaskStatus status =
    case status of
        Idle ->
            span [ class "px-3 py-1 bg-background-light text-text-secondary rounded-full text-sm" ]
                [ text "Idle" ]

        Running ->
            span [ class "px-3 py-1 bg-primary bg-opacity-20 text-primary rounded-full text-sm" ]
                [ text "Running..." ]

        Completed ->
            span [ class "px-3 py-1 bg-success bg-opacity-20 text-success rounded-full text-sm" ]
                [ text "Completed" ]

        Failed ->
            span [ class "px-3 py-1 bg-error bg-opacity-20 text-error rounded-full text-sm" ]
                [ text "Failed" ]


viewLogs : Model -> Html Msg
viewLogs model =
    div [ class "space-y-6" ]
        [ div [ class "flex items-center justify-between" ]
            [ h1 (Theme.text Theme.Heading1)
                [ text "Server Logs" ]
            , button (Theme.button Theme.Secondary ++ [ onClick ClearLogs ])
                [ text "Clear Logs" ]
            ]
        , div [ class "bg-surface rounded-lg overflow-hidden" ]
            [ div [ class "max-h-96 overflow-y-auto" ]
                (List.map viewLogEntry model.logs)
            ]
        ]


viewLogEntry : LogEntry -> Html Msg
viewLogEntry log =
    div [ class "p-4 border-b border-background-light hover:bg-background-light" ]
        [ div [ class "flex items-start space-x-3" ]
            [ viewLogLevel log.level
            , div [ class "flex-1" ]
                [ div [ class "flex items-center space-x-2 mb-1" ]
                    [ span (Theme.text Theme.Caption ++ [ class "text-text-secondary" ])
                        [ text log.timestamp ]
                    , span (Theme.text Theme.Caption ++ [ class "text-primary" ])
                        [ text log.source ]
                    ]
                , p (Theme.text Theme.Body)
                    [ text log.message ]
                ]
            ]
        ]


viewLogLevel : LogLevel -> Html Msg
viewLogLevel level =
    case level of
        Info ->
            span [ class "px-2 py-1 bg-primary bg-opacity-20 text-primary rounded text-xs font-medium" ]
                [ text "INFO" ]

        Warning ->
            span [ class "px-2 py-1 bg-warning bg-opacity-20 text-warning rounded text-xs font-medium" ]
                [ text "WARN" ]

        Error ->
            span [ class "px-2 py-1 bg-error bg-opacity-20 text-error rounded text-xs font-medium" ]
                [ text "ERROR" ]

        Debug ->
            span [ class "px-2 py-1 bg-background-light text-text-secondary rounded text-xs font-medium" ]
                [ text "DEBUG" ]


viewPlugins : Model -> Html Msg
viewPlugins model =
    div [ class "space-y-6" ]
        [ div [ class "flex items-center justify-between" ]
            [ h1 (Theme.text Theme.Heading1)
                [ text "Plugins" ]
            , button (Theme.button Theme.Primary)
                [ text "Install Plugin" ]
            ]
        , div [ class "space-y-4" ]
            (List.map viewPluginCard model.plugins)
        ]


viewPluginCard : Plugin -> Html Msg
viewPluginCard plugin =
    div [ class "bg-surface rounded-lg p-6" ]
        [ div [ class "flex items-start justify-between mb-3" ]
            [ div [ class "flex-1" ]
                [ h3 (Theme.text Theme.Heading3)
                    [ text plugin.name ]
                , p (Theme.text Theme.Caption ++ [ class "text-text-secondary" ])
                    [ text ("v" ++ plugin.version ++ " by " ++ plugin.author) ]
                , p (Theme.text Theme.Body ++ [ class "mt-2" ])
                    [ text plugin.description ]
                ]
            , button
                [ class
                    (if plugin.isEnabled then
                        "relative inline-flex h-6 w-11 items-center rounded-full bg-primary transition-colors"

                     else
                        "relative inline-flex h-6 w-11 items-center rounded-full bg-background-light transition-colors"
                    )
                , onClick (TogglePlugin plugin.name)
                ]
                [ span
                    [ class
                        (if plugin.isEnabled then
                            "inline-block h-4 w-4 transform rounded-full bg-white transition-transform translate-x-6"

                         else
                            "inline-block h-4 w-4 transform rounded-full bg-white transition-transform translate-x-1"
                        )
                    ]
                    []
                ]
            ]
        ]


viewNetworking : Model -> Html Msg
viewNetworking _ =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Networking" ]
        , div [ class "bg-surface rounded-lg p-6" ]
            [ div [ class "space-y-4" ]
                [ div []
                    [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                        [ text "Local Network Address" ]
                    , input
                        [ type_ "text"
                        , value "192.168.1.100:8096"
                        , class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary"
                        , disabled True
                        ]
                        []
                    ]
                , div []
                    [ label (Theme.text Theme.Label ++ [ class "block mb-2" ])
                        [ text "External Address" ]
                    , input
                        [ type_ "text"
                        , value "https://jellyfin.example.com"
                        , class "w-full bg-background border border-background-light rounded px-3 py-2 text-text-primary focus:outline-none focus:ring-2 focus:ring-primary"
                        ]
                        []
                    ]
                , div [ class "flex items-center justify-between" ]
                    [ div []
                        [ p (Theme.text Theme.Body ++ [ class "font-medium" ])
                            [ text "Enable HTTPS" ]
                        , p (Theme.text Theme.Caption ++ [ class "text-text-secondary" ])
                            [ text "Use secure connections" ]
                        ]
                    , button
                        [ class "relative inline-flex h-6 w-11 items-center rounded-full bg-primary transition-colors" ]
                        [ span [ class "inline-block h-4 w-4 transform rounded-full bg-white transition-transform translate-x-6" ] []
                        ]
                    ]
                ]
            ]
        ]


viewDevices : Model -> Html Msg
viewDevices _ =
    div [ class "space-y-6" ]
        [ h1 (Theme.text Theme.Heading1 ++ [ class "mb-4" ])
            [ text "Devices" ]
        , div [ class "bg-surface rounded-lg p-6" ]
            [ p (Theme.text Theme.Body ++ [ class "text-text-secondary text-center py-8" ])
                [ text "No devices registered" ]
            ]
        ]
