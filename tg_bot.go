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
	hook := tgbotapi.NewWebhook(os.Getenv("HOOK_URL"))
	_, err = bot.SetWebhook(hook)

	if err != nil {
		fmt.Printf("Problem in setting Webhook: " + err.Error())
	}

	// Set Handler for http server
	updates := bot.ListenForWebhook("/")

	// Start http server on PORT
	go http.ListenAndServe(":"+os.Getenv("PORT"), nil)

	// main loop get updates
	for update := range updates {
		log.Printf("[%s] %s", update.Message.From.UserName, update.Message.Text)

		msg := tgbotapi.NewMessage(update.Message.Chat.ID, update.Message.Text+" bot read")

		// Echo
		bot.Send(msg)
	}
}
