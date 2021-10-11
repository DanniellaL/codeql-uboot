import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class NetworkByteSwap extends Expr {
  // TODO: copy from previous step
  NetworkByteSwap () {
    // TODO: replace <class> and <var>
    exists(MacroInvocation mi|
        this = mi.getExpr() and mi.getMacroName() in ["ntohs","ntohl","ntohll"]
    )
  }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "NetworkToMemFuncLength" }

  override predicate isSource(DataFlow::Node source) {
    // TODO
    source.asExpr() instanceof NetworkByteSwap 
  }
  override predicate isSink(DataFlow::Node sink) {
    // TODO
    exists(
        FunctionCall f_Call |
        f_Call.getTarget().getName() = "memcpy" and
        sink.asExpr() = f_Call.getArgument(2)
    )
  }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"
