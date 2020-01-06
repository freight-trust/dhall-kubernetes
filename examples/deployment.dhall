let kubernetes =
      ../package.dhall sha256:0a6949aabfb5a1250f08c4e3a533024d4705bea98ace08d8d107417e54a9648a

let kv = (../Prelude.dhall).JSON.keyText

let deployment =
      kubernetes.Deployment::{
      , metadata = kubernetes.ObjectMeta::{ name = "nginx" }
      , spec =
          Some
            kubernetes.DeploymentSpec::{
            , replicas = Some 2
            , revisionHistoryLimit = Some 10
            , selector =
                kubernetes.LabelSelector::{ matchLabels = [ kv "app" "nginx" ] }
            , strategy =
                Some
                  kubernetes.DeploymentStrategy::{
                  , type = Some "RollingUpdate"
                  , rollingUpdate =
                      { maxSurge = Some (kubernetes.IntOrString.Int 5)
                      , maxUnavailable = Some (kubernetes.IntOrString.Int 0)
                      }
                  }
            , template =
                kubernetes.PodTemplateSpec::{
                , metadata =
                    kubernetes.ObjectMeta::{
                    , name = "nginx"
                    , labels = [ kv "app" "nginx" ]
                    }
                , spec =
                    Some
                      kubernetes.PodSpec::{
                      , containers =
                          [ kubernetes.Container::{
                            , name = "nginx"
                            , image = Some "nginx:1.15.3"
                            , imagePullPolicy = Some "Always"
                            , ports =
                                [ kubernetes.ContainerPort::{
                                  , containerPort = 80
                                  }
                                ]
                            , resources =
                                Some
                                  { limits = [ kv "cpu" "500m" ]
                                  , requests = [ kv "cpu" "10m" ]
                                  }
                            }
                          ]
                      }
                }
            }
      }

in  deployment
