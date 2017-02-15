RSpec.describe Dory::Systemd do
  let(:cups_disabled_not_running) do
    return <<~EOF
      ● cups.service - CUPS Scheduler
         Loaded: loaded (/usr/lib/systemd/system/cups.service; disabled; vendor preset: enabled)
         Active: inactive (dead) since Mon 2017-02-13 15:29:13 AKST; 1min 29s ago
           Docs: man:cupsd(8)
       Main PID: 3043 (code=exited, status=0/SUCCESS)
         Status: "Scheduler is running..."

      Feb 13 05:26:58 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 06:25:18 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 07:23:38 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 08:21:58 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 09:20:18 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 10:18:38 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 11:16:58 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 15:26:00 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 15:29:13 ben systemd[1]: Stopping CUPS Scheduler...
      Feb 13 15:29:13 ben systemd[1]: Stopped CUPS Scheduler.
    EOF
  end

  let(:cups_enabled_not_running_retval) do
      OpenStruct.new(success?: false, exitstatus: 3, stdout: cups_enabled_not_running)
  end

  let(:cups_enabled_not_running) do
    <<~EOF
      ● cups.service - CUPS Scheduler
         Loaded: loaded (/usr/lib/systemd/system/cups.service; enabled; vendor preset: enabled)
         Active: inactive (dead) since Mon 2017-02-13 15:29:13 AKST; 1s ago
           Docs: man:cupsd(8)
       Main PID: 3043 (code=exited, status=0/SUCCESS)
         Status: "Scheduler is running..."

      Feb 13 05:26:58 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 06:25:18 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 07:23:38 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 08:21:58 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 09:20:18 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 10:18:38 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 11:16:58 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 15:26:00 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 15:29:13 ben systemd[1]: Stopping CUPS Scheduler...
      Feb 13 15:29:13 ben systemd[1]: Stopped CUPS Scheduler.
    EOF
  end

  let(:cups_enabled_and_running_retval) do
      OpenStruct.new(success?: true, stdout: cups_enabled_and_running)
  end

  let(:cups_enabled_and_running) do
    <<~EOF
      ● cups.service - CUPS Scheduler
         Loaded: loaded (/usr/lib/systemd/system/cups.service; enabled; vendor preset: enabled)
         Active: active (running) since Fri 2017-02-10 17:38:08 AKST; 2 days ago
           Docs: man:cupsd(8)
       Main PID: 3043 (cupsd)
         Status: "Scheduler is running..."
          Tasks: 1 (limit: 512)
         CGroup: /system.slice/cups.service
                 └─3043 /usr/sbin/cupsd -l

      Feb 13 03:30:18 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 04:28:38 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 05:26:58 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 06:25:18 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 07:23:38 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 08:21:58 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 09:20:18 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 10:18:38 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 11:16:58 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 13 15:26:00 ben cupsd[3043]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
    EOF
  end

  let(:cups_not_installed_retval) do
      OpenStruct.new(success?: false, exitstatus: 3, stdout: cups_not_installed)
  end

  let(:cups_not_installed) do
    <<~EOF
      ● cups.service
         Loaded: not-found (Reason: No such file or directory)
         Active: inactive (dead)
    EOF
  end

  let(:cups_disabled_and_running) do
    <<~EOF
      ● cups.service - CUPS Scheduler
         Loaded: loaded (/usr/lib/systemd/system/cups.service; disabled; vendor preset: enabled)
         Active: active (running) since Mon 2017-02-13 16:24:20 AKST; 19h ago
           Docs: man:cupsd(8)
       Main PID: 1201 (cupsd)
         Status: "Scheduler is running..."
          Tasks: 1 (limit: 512)
         CGroup: /system.slice/cups.service
                 └─1201 /usr/sbin/cupsd -l

      Feb 14 02:39:21 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 14 03:37:41 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 14 04:36:01 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 14 05:34:21 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 14 06:32:41 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 14 07:31:01 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 14 08:29:21 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 14 09:27:41 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 14 10:26:01 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
      Feb 14 11:24:21 ben cupsd[1201]: REQUEST localhost - - "POST / HTTP/1.1" 200 1
    EOF
  end

  describe '#has_systemd?' do
    let(:which_not_found) do
      '/usr/bin/which: no systemctl in (/home/ben/.gem/ruby/2.4.0/bin:/home/ben/.' \
      'rubies/ruby-2.4.0/lib/ruby/gems/2.4.0/bin:/home/ben/.rubies/ruby-2.4.0/bin:' \
      '/home/ben/.linuxbrew/bin:/home/ben/.nvm/versions/node/v6.4.0/bin:' \
      '/home/ben/.linuxbrew/bin:/home/ben/.linuxbrew/bin:/home/ben/.linuxbrew/bin:' \
      '/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:' \
      '/usr/local/sbin:/home/ben/bin:/home/ben/go/bin:/usr/local/sbin:/home/ben/go/bin)'
    end

    it 'knows if systemd is installed' do
      expect(Dory::Sh).to receive(:run_command).with('which systemctl') do
        OpenStruct.new(success?: true, stdout: '/usr/bin/systemctl')
      end
      expect(Dory::Systemd).to have_systemd
    end

    it 'knows if systemd is NOT installed' do
      expect(Dory::Sh).to receive(:run_command).with('which systemctl') do
        OpenStruct.new(success?: false, stdout: which_not_found, exitstatus: 1)
      end
      expect(Dory::Systemd).not_to have_systemd
    end
  end

  describe '#systemd_service_installed?' do
    it 'knows cups is installed' do
      [
        cups_enabled_not_running,
        cups_enabled_and_running,
        cups_disabled_not_running
      ].each do |cups|
        allow(Dory::Sh).to receive(:run_command) do
          OpenStruct.new(success?: true, stdout: cups)
        end
        expect(Dory::Systemd.systemd_service_installed?('cups')).to be_truthy
      end
    end

    # we can do this without stubbing once travis is on a distro with systemd
    it 'knows cups is not installed' do
      allow(Dory::Sh).to receive(:run_command) { cups_not_installed_retval }
      expect(Dory::Systemd.systemd_service_installed?('cups')).to be_falsey
    end
  end

  describe '#systemd_service_running?' do
    it 'knows cups is running' do
      allow(Dory::Sh).to receive(:run_command) do
        OpenStruct.new(success?: true, stdout: cups_enabled_and_running)
      end
      expect(Dory::Systemd.systemd_service_running?('cups')).to be_truthy
    end

    it 'knows cups is not running' do
      allow(Dory::Sh).to receive(:run_command) do
        OpenStruct.new(success?: true, stdout: cups_enabled_not_running)
      end
      expect(Dory::Systemd.systemd_service_running?('cups')).to be_falsey
    end

    it 'doesnt think non-installed services are running' do
      allow(Dory::Sh).to receive(:run_command) { cups_not_installed_retval }
      expect(Dory::Systemd.systemd_service_running?('cups')).to be_falsey
    end
  end

  describe '#systemd_service_enabled?' do
    it 'knows cups is enabled' do
      allow(Dory::Sh).to receive(:run_command) do
        OpenStruct.new(success?: true, stdout: cups_enabled_and_running)
      end
      expect(Dory::Systemd.systemd_service_enabled?('cups')).to be_truthy
    end

    it 'knows cups is enabled even if not running' do
      allow(Dory::Sh).to receive(:run_command) do
        OpenStruct.new(success?: true, stdout: cups_enabled_not_running)
      end
      expect(Dory::Systemd.systemd_service_enabled?('cups')).to be_truthy
    end

    it 'knows cups is disabled' do
      allow(Dory::Sh).to receive(:run_command) do
        OpenStruct.new(success?: true, stdout: cups_disabled_not_running)
      end
      expect(Dory::Systemd.systemd_service_enabled?('cups')).to be_falsey
    end

    it 'knows cups is disabled even if running' do
      allow(Dory::Sh).to receive(:run_command) do
        OpenStruct.new(success?: true, stdout: cups_disabled_and_running)
      end
      expect(Dory::Systemd.systemd_service_enabled?('cups')).to be_falsey
    end
  end

  describe '#set_systemd_service' do
    let(:stub_if_needed) do
      # on systems without systemd we have to stub this
      ->(now_running) do
        puts 'Checking stub if needed'.blue
        unless Dory::Systemd.has_systemd?
          puts 'Doesnt have systemd'.blue
          if (now_running)
            puts 'stubbing now running true'.blue
            allow(Dory::Sh).to receive(:run_command) { cups_enabled_and_running_retval }
          else
            puts 'stubbing now running false'.blue
            allow(Dory::Sh).to receive(:run_command) { cups_enabled_not_running_retval }
          end
        else
          puts 'does have systemd.  no stubbing'.blue
        end
      end
    end

    it 'puts the service down' do
      stub_if_needed.call(true)
      Dory::Systemd.set_systemd_service(service: 'cups', up: true)
      expect {
        stub_if_needed.call(false)
        Dory::Systemd.set_systemd_service(service: 'cups', up: false)
      }.to change {
        Dory::Systemd.systemd_service_running?('cups')
      }.from(true).to(false)
    end

    it 'brings the service up' do
      stub_if_needed.call(false)
      Dory::Systemd.set_systemd_service(service: 'cups', up: false)
      expect {
        stub_if_needed.call(true)
        Dory::Systemd.set_systemd_service(service: 'cups', up: true)
      }.to change {
        Dory::Systemd.systemd_service_running?('cups')
      }.from(false).to(true)
    end
  end
end
