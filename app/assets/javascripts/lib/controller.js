var action, controller, namespace;

action = function() {
  return $("body").data("action");
};

controller = function() {
  return $("body").data("controller");
};

namespace = function() {
  return $("body").data("namespace");
};
