def url(data_ida, data_volta, pessoas)
  "http://www.kayak.com.br/flights/RIO-REC/#{data_ida}/#{data_volta}/#{pessoas}adults"
end

task :procura_passagens => :environment do

  TEMPO_ESPERA = 60

  DELAY = 3600

  THRESHOLD = 400

  QUERIES= [{ida: "2015-03-05", volta: "2015-03-09", pessoas: '1'}]

  begin
    #PassagemMailer.envia_passagem("teste").deliver

    @browser = Watir::Browser.new
    @f = File.open("#{DateTime.now.strftime("%m-%d_%H-%M-%S")}.txt", 'w+')
    QUERIES.each do |query|
      @browser.goto(url(query[:ida], query[:volta], query[:pessoas]))
      sleep TEMPO_ESPERA
      puts "#{query[:ida]} - #{query[:volta]}"
      @f.write("#{query[:ida]} - #{query[:volta]}\n")
      @browser.elements(:css => ".flightresult").each do |el|
        # binding.pry

        price  = el.elements(:css => '.pricerange a').first.inner_html.gsub(/\D/ , '').to_i


        # .gsub(/\D/ , '').to_i
        # binding.pry
        airline = el.elements(:css => '.airlineName').first.inner_html
        voos = []
        el.elements(:css => '.singleleg').each do |voo|
          voos << {saida: voo.elements(:css => '.flightTimeDeparture').first.inner_html,
                   chegada: voo.elements(:css => '.flightTimeArrival').first.inner_html,
                   duracao: voo.elements(:css => '.duration').first.inner_html
          }
        end
        email_body =""
        puts "R$ #{price} - #{airline}"
        email_body += "R$ #{price} - #{airline}"
        @f.write("R$ #{price} - #{airline}\n")
        voos.each do |voo|
          puts "#{voo[:saida]} - #{voo[:chegada]}  duracao: #{voo[:duracao]}"
          @f.write("#{voo[:saida]} - #{voo[:chegada]}  duracao: #{voo[:duracao]}\n")
          email_body += "#{voo[:saida]} - #{voo[:chegada]}  duracao: #{voo[:duracao]}\n"
        end

        puts "#{price <= THRESHOLD} - #{price} <= #{THRESHOLD}"
        PassagemMailer.envia_passagem(email_body).deliver if price <= THRESHOLD

        puts ""
      end

      puts ""
      puts "\n------------------------------------------------------------------------------------------\n"
      puts ""
      @f.write("\n------------------------------------------------------------------------------------------\n\n")
    end
    @f.close

  rescue Exception => e
    puts e.message
    begin
      @f.write("ERRO!!!!\n#{e.message}\n")
    rescue
    end
  ensure
    begin
      @browser.close
    rescue
    end
    begin
      @f.close
    rescue
    end
  end


end