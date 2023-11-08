package web

import (
	"context"
	_ "embed"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/deliveroo/platform-code-test-app/config"
	"github.com/deliveroo/platform-code-test-app/logging"
	"github.com/deliveroo/platform-code-test-app/web/handler"

	"github.com/rs/zerolog/log"

	accesslog "github.com/mash/go-accesslog"
)

type WebProvider interface {
	Run(ctx context.Context)
	SetupRouter(ctx context.Context) *http.ServeMux
}

type web struct {
	Config             config.Config
	ConnectedHandler   *handler.ConnectHandler
	HealthcheckHandler *handler.HealthcheckHandler
	HelloHandler       *handler.HelloHandler
	ThirdpartyHandler  *handler.ThirdpartyHandler
}

func NewWeb(cfg config.Config) WebProvider {
	connectHandler := handler.NewConnectHandler(HtmlTmpls, cfg)
	healthcheckHandler := handler.NewHealthcheckHandler()
	helloHandler := handler.NewHelloHandler(HtmlTmpls)
	thirdpartyHandler := handler.NewThirdpartyHandler(HtmlTmpls)

	web := web{
		Config:             cfg,
		ConnectedHandler:   connectHandler,
		HealthcheckHandler: healthcheckHandler,
		HelloHandler:       helloHandler,
		ThirdpartyHandler:  thirdpartyHandler,
	}
	return web
}

func (w web) Run(ctx context.Context) {
	var runChan = make(chan os.Signal, 1)

	router := w.SetupRouter(ctx)
	httpLogger := logging.HttpLogger{}

	server := &http.Server{
		Addr:         w.Config.Server.Host + ":" + w.Config.Server.Port,
		Handler:      accesslog.NewLoggingHandler(router, httpLogger),
		IdleTimeout:  time.Duration(w.Config.Server.Timeout.Idle) * time.Second,
		ReadTimeout:  time.Duration(w.Config.Server.Timeout.Read) * time.Second,
		WriteTimeout: time.Duration(w.Config.Server.Timeout.Write) * time.Second,
	}

	_ = notifySignals(runChan)

	log.Log().Msgf("Server is starting on %s", server.Addr)

	go func() {
		if err := server.ListenAndServe(); err != nil {
			if err == http.ErrServerClosed {
			} else {
				log.Fatal().Err(err).Msg("Server failed to start")
			}
		}
	}()

	interrupt := <-runChan
	log.Log().Msgf("Server is shutting down due to %+v", interrupt)
	if err := server.Shutdown(ctx); err != nil {
		log.Fatal().Err(err).Msg("Server was unable to gracefully shutdown")
	}
}

func (w web) SetupRouter(ctx context.Context) *http.ServeMux {
	router := http.NewServeMux()

	router.HandleFunc("/connect", w.ConnectedHandler.Http)
	router.HandleFunc("/healthcheck", w.HealthcheckHandler.Http)
	router.HandleFunc("/thirdparty", w.ThirdpartyHandler.Http)
	router.HandleFunc("/", w.HelloHandler.Http)

	return router
}

func notifySignals(runChan chan os.Signal) chan os.Signal {
	signal.Notify(runChan, os.Interrupt, syscall.SIGTSTP)
	return runChan
}
