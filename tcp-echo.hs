import Network
import System.Environment
import System.IO
import Control.Concurrent

main = do
  -- read port from command line
  argv <- getArgs
  let port = fromIntegral (read $ head argv)
  -- listen on the given port
  socket <- listenOn $ PortNumber port
  putStrLn $ "Listening on " ++ (show port)
  -- start main loop
  mainLoop socket

mainLoop socket = do
  -- accept clients
  (socketH, host, port) <- accept socket
  hPutStr socketH ("Welcome " ++ host ++ "\n")
  -- initialize socket
  initSocket socketH
  -- next iteration
  mainLoop socket

initSocket socketH = do
  -- start concurrent command loop
  forkIO (cmdLoop socketH)

cmdLoop socketH = do
  -- read line from socket
  line <- hGetLine socketH
  -- echo the same line
  hPutStr socketH (line ++ "\n")
  -- next iteration
  cmdLoop socketH

