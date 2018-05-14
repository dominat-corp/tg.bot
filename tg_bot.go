package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"gopkg.in/telegram-bot-api.v4"
)

func main() {
	bot, err := tgbotapi.NewBotAPI(os.Getenv("TELEGRAM_TOKEN"))

	bot.Debug = true

	if err != nil {
		log.Panic(err)
	}

	log.Printf("Authorized on account %s", bot.Self.UserName)

	// Setting web hook https protocol
	_, err = bot.SetWebhook(tgbotapi.NewWebhookWithCert(os.Getenv("HOOK_URL")+bot.Token, "/cert/webhook_cert.pem"))

	if err != nil {
		fmt.Printf("Problem in setting Webhook: " + err.Error())
	}

	// Set Handler for http server
	updates := bot.ListenForWebhook("/" + bot.Token)

	// Start http server on PORT
	go http.ListenAndServeTLS(":"+os.Getenv("PORT"), "/cert/webhook_cert.pem", "/cert/webhook_pkey.pem", nil)

	// main loop get updates
	for update := range updates {
		log.Printf("[%s] %s", update.Message.From.UserName, update.Message.Text)

		msg := tgbotapi.NewMessage(update.Message.Chat.ID, update.Message.Text+" bot read")

		// Echo
		bot.Send(msg)
	}
}
