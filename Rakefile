
namespace :app do
  task:start do
    trap('SIGINT') { exit; }
    %x{bundle exec thin -R config.ru -a 127.0.0.1 -p 8000 start}
  end
end
