package main

import (
  "fmt"
  "log"
  "strings"
  "time"
  "sync"

  "github.com/godbus/dbus/v5"
  "github.com/godbus/dbus/v5/introspect"
)

type Notification struct {
  Summary  string
  Body     string
  Icon     string
  ExpireAt time.Time
}

var (
  notifications     []Notification
  notificationMutex sync.RWMutex
  notificationChan  = make(chan Notification, 10)
  quitChan          = make(chan struct{})
)

func printState() {
  notificationMutex.RLock()
  defer notificationMutex.RUnlock()

  var output strings.Builder
  output.WriteString("(box :orientation 'vertical'")
  for _, n := range notifications {
    fmt.Fprintf(&output, ` (button :class 'notif'
    (box :orientation 'horizontal' :space-evenly false
    (image :image-width 64 :image-height 64 :path '%s')
    (box :orientation 'vertical'
    (label :width 80 :wrap true :text '%s')
    (label :width 80 :wrap true :text '%s')
  )))`, n.Icon, n.Summary, n.Body)
}
output.WriteString(")")
fmt.Println(strings.ReplaceAll(output.String(), "\n", " "))
}

type NotificationServer struct{}

func (s *NotificationServer) Notify(_ string, _ uint32, appIcon, summary, body string, _ []string, _ map[string]dbus.Variant, _ int32) (uint32, *dbus.Error) {
  notificationChan <- Notification{
    Summary:  summary,
    Body:     body,
    Icon:     appIcon,
    ExpireAt: time.Now().Add(5 * time.Second),
  }
  return 0, nil
}

func (s *NotificationServer) GetCapabilities() ([]string, *dbus.Error) {
  return []string{"body", "body-markup", "icon-static"}, nil
}

func (s *NotificationServer) GetServerInformation() (string, string, string, string, *dbus.Error) {
  return "GoNotificationServer", "Example.com", "1.0", "1.2", nil
}

func (s *NotificationServer) CloseNotification(id uint32) *dbus.Error {
  return nil
}

const introspectXML = `
<node>
<interface name="org.freedesktop.Notifications">
<method name="Notify">
<arg direction="in" type="s"/>
<arg direction="in" type="u"/>
<arg direction="in" type="s"/>
<arg direction="in" type="s"/>
<arg direction="in" type="s"/>
<arg direction="in" type="as"/>
<arg direction="in" type="a{sv}"/>
<arg direction="in" type="i"/>
<arg direction="out" type="u"/>
</method>
<method name="CloseNotification">
<arg direction="in" type="u"/>
</method>
<method name="GetCapabilities">
<arg direction="out" type="as"/>
</method>
<method name="GetServerInformation">
<arg direction="out" type="s"/>
<arg direction="out" type="s"/>
<arg direction="out" type="s"/>
<arg direction="out" type="s"/>
</method>
</interface>
</node>`

func notificationManager() {
  ticker := time.NewTicker(1 * time.Second)
  defer ticker.Stop()

  for {
    select {
    case newNotification := <-notificationChan:
      notificationMutex.Lock()
      notifications = append([]Notification{newNotification}, notifications...)
      if len(notifications) > 5 {
        notifications = notifications[:5]
      }
      notificationMutex.Unlock()
      printState()
    case <-ticker.C:
      now := time.Now()
      notificationMutex.Lock()
      updatedNotifications := notifications[:0]
      for _, n := range notifications {
        if now.Before(n.ExpireAt) {
          updatedNotifications = append(updatedNotifications, n)
        }
      }
      if len(updatedNotifications) != len(notifications) {
        notifications = updatedNotifications
        notificationMutex.Unlock()
        printState()
      } else {
        notificationMutex.Unlock()
      }
    case <-quitChan:
      return
    }
  }
}

func main() {
  log.Println("Starting notification server...")

  conn, err := dbus.SessionBus()
  if err != nil {
    log.Fatal(err)
  }

  n := &NotificationServer{}
  err = conn.Export(n, "/org/freedesktop/Notifications", "org.freedesktop.Notifications")
  if err != nil {
    log.Fatal(err)
  }

  err = conn.Export(introspect.Introspectable(introspectXML), "/org/freedesktop/Notifications",
  "org.freedesktop.DBus.Introspectable")
  if err != nil {
    log.Fatal(err)
  }

  reply, err := conn.RequestName("org.freedesktop.Notifications",
  dbus.NameFlagDoNotQueue)
  if err != nil {
    log.Fatal(err)
  }
  if reply != dbus.RequestNameReplyPrimaryOwner {
    log.Fatal("Name already taken")
  }

  go notificationManager()

  log.Println("Notification server is running. Waiting for notifications...")

  // Keep the program running
  select {}
}
