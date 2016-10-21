function ild(p)
  button1_repetition = 0;
  button2_repetition = 0;
  te1 = "Otvaram ";
  te2 = "branu ";
  if p == 0 then te3 = "Margaretova" else  te3 = "Hrusovska"; end

  file.open("parking.MONO", "r")
  xbm_data = file.read()
  file.close()
  display_o(xbm_data, te1, te2, te3, 1)

  tmr.alarm(2, 3000, 1, function()
    if pic == 0 or pic == nil then
      display_o(xbm_data, te1, te2, te3, 0)
    end
    
    if pic == 1 then
      display_o(xbm_data, te1, te2, te3, 1)
    end
    
    pic = pic + 1
    if pic == 2 then
      pic = 0
    end
  end)
  gpio.write(p, gpio.HIGH);
  tmr.delay(k_press);
  gpio.write(p, gpio.LOW);
end
