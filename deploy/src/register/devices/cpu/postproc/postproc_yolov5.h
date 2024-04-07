#pragma once

#include "core/result_def.h"
#include "core/mem/buf_surface_util.h"
#include "core/model.h"
#include "util/common_def.h"

namespace gddeploy {

int Yolov5DecodeOutputNCHW(std::vector<gddeploy::BufSurfWrapperPtr> out_data, 
                                    gddeploy::InferResult &result,  
                                    gddeploy::PostParam &param,  
                                    std::vector<FrameInfo> frame_info, 
                                    gddeploy::ModelPtr model_ptr);
int Yolov5DecodeOutputNHWC(std::vector<gddeploy::BufSurfWrapperPtr> out_data, 
                                    gddeploy::InferResult &result,  
                                    gddeploy::any param,  
                                    std::vector<FrameInfo> frame_info, 
                                    gddeploy::ModelPtr model_ptr);
int Yolov5DecodeOutputNCHWSigmoid(std::vector<gddeploy::BufSurfWrapperPtr> out_data, 
                                    gddeploy::InferResult &result,  
                                    gddeploy::any param,  
                                    std::vector<FrameInfo> frame_info, 
                                    gddeploy::ModelPtr model_ptr);
int Yolov5DecodeOutput(std::vector<gddeploy::BufSurfWrapperPtr> out_data, 
                                    gddeploy::InferResult &result,  
                                    gddeploy::PostParam &param,  
                                    std::vector<FrameInfo> frame_info, 
                                    gddeploy::ModelPtr model_ptr);
}