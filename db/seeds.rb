Project.create(name: "🆒  NRT")
Project.create(name: "🌏  Protected Planet")
Project.create(name: "🐙  Species+")

Metric.create(
  name: "Total Downloads",
  data: [{
    date: 2.days.ago.to_i,
    value: 5
  }, {
    date: Time.now.to_i,
    value: 10
  }]
)
