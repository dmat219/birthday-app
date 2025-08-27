# Birthday App - Product Requirements Document (PRD)

## 📋 **Context**
Wishing someone happy birthday takes <30s and means a lot to people. Right now the most reliable source of birthdays is Facebook, but the app is so bloated and unpleasant to visit.

## 🎯 **Problem Statement**
It's difficult to keep track of friends over time and remember to wish them happy birthday. This is problematic because it can lead to atrophy of relationships.

## 🚀 **Product Vision**
The app will send a daily digest of your friends birthdays. The app would allow you to send personalized texts, e-cards, and gifts with a few button clicks.

Gift options include sending e-gift cards, scheduling flower deliveries, or sending presents (from amazon or other popular online sellers).

If successful, the app could be expanded to support anniversaries, holidays, or any other event that prompts gift giving.

## 👥 **Critical User Journeys**

### **Onboarding**
- **[sync-birthdays]** I want to sync birthdays from existing sources, so I…
  - Easily sync birthdays from existing phone contacts, Facebook, or WhatsApp
- **[manually-update]** I want to manually manage birthdays for my friends and family that aren't available from the sync, so I..
  - Search my contacts in the app and add a birthday.
  - In rare cases I may create an entry for someone who is not in my existing contacts

### **Sending Birthdays**
- **[receive-digest]** I want to know which birthdays are happening today, so I…
  - Receive a notification that shows a list of the birthdays today
- **[send-text]** I want to wish one of my friends happy birthday, so I…
  - Click on the name to open up my preferred messaging app with a draft message to the person
  - I modify my message and hit send
- **[send-e-card]** I want to wish one of my friends happy birthday, so I…
  - Click on the name of the contact from the digest
  - I'm taken to a page with suggested e-cards that I can select and personalize
  - Once I'm happy with my e-card, I send it to my friend with my preferred messaging app.

- **[send-gift]** I want to send my friend a gift, so I...
  - Click on the name of the contact from the digest
  - I'm taken to a page with suggested gift categories (e.g., food delivery, flowers, gift cards, entertainment)
  - Click on one of the suggested options to complete checkout

## 💰 **Monetization Options**
We can monetize in the following ways:
- Advertise potential birthday gifts
- Pay for no ads
- Pay to send special e-card
- Concept of a "birthday registry" similar to a wedding registry

## 🔄 **Current Status & Implementation Notes**

### **Phase 1 (Current) - Safari Redirects**
- ✅ Basic birthday management and notifications
- ✅ Contact import functionality
- ✅ Message and e-card sending
- ✅ Gift options with Safari redirects to gift card sections
- ✅ Sophisticated Phase 2-style UI for gift selection
- ✅ Category-based filtering (Food, Retail, Entertainment, Flowers)

### **Phase 2 (Future) - Integrated Checkout**
- 🔄 Gift card aggregation APIs integration
- 🔄 Unified checkout experience within the app
- 🔄 Apple Pay integration
- 🔄 Gift delivery management

### **Technical Foundation**
- ✅ SwiftUI-based iOS app
- ✅ BirthdayStore with ObservableObject pattern
- ✅ Notification management
- ✅ Contact import via CNContactStore
- ✅ Message composition via MessageUI
- ✅ Safari integration for web-based gift options

## 📱 **Platform & Requirements**
- **Platform**: iOS (iPhone)
- **Framework**: SwiftUI
- **Target**: iOS 16.2+
- **Deployment**: App Store

## 🎨 **Design Principles**
- **Simplicity**: Easy to use, minimal friction
- **Reliability**: Consistent birthday reminders
- **Personalization**: Customizable messages and gift options
- **Integration**: Seamless connection with existing messaging and gift services
- **Scalability**: Please build the program to be simple, scalable, and modular
- **Best practices**: Please follow all best practices for app development and UI/UX. Please ensure that all items are initialized properly, meaning that state management is addressed properly
- **Testability**: Please make code easy to test and debug. Log errors so that it's easy for us to fix things


---

*Last Updated: August 26, 2025*
*Status: Phase 1 Complete, Phase 2 Planning*
