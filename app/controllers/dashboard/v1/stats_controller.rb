class Dashboard::V1::StatsController < DashboardController

  def keyword
    @messages_sent_count = Message.where(kind: "outgoing", )
  end
end