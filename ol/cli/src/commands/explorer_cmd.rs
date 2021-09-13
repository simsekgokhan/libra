//! `monitor-cmd` subcommand

use crate::explorer::{ui, App};
use crate::{
    application::app_config,
    entrypoint,
    explorer::event::{Config, Event, Events},
    node::{client, node::Node},
};
use abscissa_core::{Command, Options, Runnable};
use std::time::Duration;
use std::io;
use termion::{event::Key, raw::IntoRawMode, screen::AlternateScreen};
use tui::backend::TermionBackend;
use tui::Terminal;

/// `explorer-cmd` subcommand
#[derive(Command, Debug, Options)]
pub struct ExplorerCMD {
    ///
    #[options(help = "Start pilot detached")]
    pilot: bool,
    ///
    #[options(help = "Don't refresh checks")]
    skip_checks: bool,
    ///
    #[options(help = "Tick rate of the screen", default = "250")]
    tick_rate: u64,
    ///
    #[options(help = "Using enhanced graphics", default = "true")]
    enhanced_graphics: bool,
}

impl Runnable for ExplorerCMD {
    /// Start the application.
    fn run(&self) {
    
        let args = entrypoint::get_args();
        let is_swarm = *&args.swarm_path.is_some();
        let mut cfg = app_config().clone();
        let client = client::pick_client(args.swarm_path, &mut cfg).unwrap();
        let mut node = Node::new(client, &cfg, is_swarm);

        if *&self.pilot {
          node.start_pilot(false);
        }

        let mut app = App::new(" Console ", self.enhanced_graphics, node);
        app.fetch();

        let events = Events::with_config(Config {
            tick_rate: Duration::from_millis(self.tick_rate),
            ..Config::default()
        });

        let stdout = io::stdout()
            .into_raw_mode()
            .expect("Failed to initial screen");
        //let stdout = MouseTerminal::from(stdout);
        let stdout = AlternateScreen::from(stdout);
        let backend = TermionBackend::new(stdout);
        let mut terminal = Terminal::new(backend).expect("Failed to initial screen");

        terminal.clear().unwrap();

        loop {
            terminal
                .draw(|f| ui::draw(f, &mut app))
                .expect("failed to draw screen");

            match events.next().unwrap() {
                Event::Input(key) => match key {
                    Key::Ctrl(c) => {
                        if c == 'c' {
                            app.should_quit = true;
                            break;
                        }
                    }
                    Key::Char(character) => {
                        app.on_key(character);
                    }
                    Key::Up => {
                        app.on_up();
                    }
                    Key::Down => {
                        app.on_down();
                    }
                    Key::Left => {
                        app.on_left();
                    }
                    Key::Right => {
                        app.on_right();
                    }
                    _ => {}
                },
                Event::Tick => {
                    app.on_tick();
                }
            }
            if app.should_quit {
                break;
            }
        }
        terminal.clear().unwrap();
        drop(terminal);
    }
}
